require 'rails_helper'
require 'omega'

RSpec.describe Omega do
  describe 'fetch_and_update' do
  end

  describe 'fetch' do
    # VCR setup?
  end

  describe 'convert_to_pennies' do
    # string pennies
    [['$12.34', 1234],
     ['56.78',  5678],
     ['$19.99', 1999]
    ].each do |price, pennies|
      it "converts #{price} into #{pennies} pennies" do
        expect(Omega.convert_to_pennies price).to eq pennies
      end
    end
  end

  describe 'update_product' do
    let!(:product) { Product.create external_product_id: 123,
                                    product_name: 'foobar',
                                    price: 1999
                   }
    it 'do nothing when price unchanged' do
      record = {'price' => '$19.99'}
      expect {
        Omega.update_product product, record
      }.to change(PastPriceRecord, :count).by 0
      product.reload
      expect(product.created_at).to eq product.updated_at
    end

    it 'creates new past record and update product' do
      record = {'price' => '$18.88'}
      expect {
        Omega.update_product product, record
      }.to change(PastPriceRecord, :count).by 1
      product.reload
      expect(product.price).to eq 1888
    end
  end

  describe 'update' do
    let!(:product) { Product.create external_product_id: 213,
                                    product_name: 'nice chair',
                                    price: 1999
                    }

    context 'name matches' do
      expect(Omega).to receive(:update_product)
      record = {'id' => 1234,
                'name' => 'nice chair',
                'price' => '$12.34'
               }
      Omega.update product, record
    end

    context 'name mismatch' do
      record = {'id' => 1234,
                'name' => 'ratty old chair',
                'price' => '$12.34'
               }
      expect(Rails.logger).to receive(:error).with /Product has a name mismatch!/
      Omega.update product, record
    end
  end

  describe 'create_new_product' do
    it 'success' do
      expect(Rails.logger).to receive(:info).with /Created new product called foo, internal id is/
      expect {
        Omega.create_new_product 'id' => 1234,
                                 'name' => 'foo',
                                 'price' => '$12.34'
      }.to change(Product, :count).by 1
    end

    it 'failure' do
      record = {'id' => 1234,
                'price' => '$12.34'
               }
      expect(Rails.logger).to receive(:error).with "Problem creating new product, raw data #{record.inspect}"
      expect {
        Omega.create_new_product record
      }.to change(Product, :count).by 0
    end
  end

  describe 'process_record' do
    context 'product found' do
      # verify that the next method in the chain is called
      Product.create external_product_id: 213,
                     product_name: 'nice chair',
                     price: 1999
      json = {'external_product_id' => 123}
      expect(Omega).to receive(:update)
      Omega.process_record json
    end

    context 'product not found' do
      it 'creates product if not discontinued' do
        record = {'id' => 213,
                  'name' => 'foo',
                  'price' => '$14.95',
                  'discontinued' => false}
        expect {
          Omega.process_record record
        }.to change(Product, :count).by 1
      end

      it 'does nothing when discontinued' do
        record = {'id' => 213,
                  'name' => 'foo',
                  'price' => '$14.95',
                  'discontinued' => true}
        expect {
          Omega.process_record record
        }.to change(Product, :count).by 0
      end
    end
  end

  describe 'update_all' do
    it 'stops when given invalid data' do
      expect(Rails.logger).to receive(:error).with "Unrecognized data from Omega Pricing Inc"
      Omega.update_all foo: :bar
    end

    it 'process records' do
      json = {'productRecords' => [{"id": 123}]}
      expect(Omega).to receive(:process_record)
      Omega.update_all json
    end
  end

end
