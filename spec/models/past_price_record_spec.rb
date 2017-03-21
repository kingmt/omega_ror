require 'rails_helper'

RSpec.describe PastPriceRecord, type: :model do
  describe 'log_change' do
    it 'creates new record' do
      product = Product.create product_name: 'foo', external_product_id: 1234, price: 10
      expect {
        PastPriceRecord.log_change product: product, new_price: 11
      }.to change(PastPriceRecord, :count).by 1
      ppr = PastPriceRecord.last
      expect(ppr.product_id).to eq product.id
      expect(ppr.price).to eq 10
      expect(ppr.percentage_change).to eq 0.1
    end
  end

  describe 'find_percentage_change' do
    # old price, new price percentage
    [[10, 11,  0.10],
     [20, 22,  0.10],
     [20, 40,  1.00],
     [12, 10, -0.17],
     [24, 20, -0.17],
     [22, 11, -0.50]
    ].each do |old_price, new_price, expected|
      it "calculates the change from #{old_price} to #{new_price} to be #{expected}" do
        expect(PastPriceRecord.find_percentage_change old_price, new_price).to eq expected
      end
    end
  end
end
