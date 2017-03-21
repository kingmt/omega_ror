require 'rails_helper'
require 'omega'

RSpec.describe Omega do
  product
  describe 'fetch_and_update' do
  end

  describe 'fetch' do
  end

  describe 'convert_to_pennies' do
    it 'handles with $' do
      expect(Omega.convert_to_pennies '$12.34').to eq 1234
    end

    it 'without the $' do
      expect(Omega.convert_to_pennies '$56.78').to eq 5678
    end
  end

  describe 'update_product' do
    it 'do nothing when price unchanged' do
      product
    end

    it 'creates new past record and update product'
  end

  describe 'update' do
    # debatable if this needs a test or not
    # this method doesn't do any real work
    # it delegates to a method to do work
    # or fires a logger statement
    # what could be tested is making sure
    # that the methods are called
  end

  describe 'create_new_product' do
    it 'success' do
      expect {
        Omega.create_new_product 'id' => 1234,
                                 'name' => 'foo',
                                 'price' => '$12.34'
      }.to change(Product, :count).by 1
    end

    it 'failure' do
      expect {
        Omega.create_new_product 'id' => 1234,
                                 'price' => '$12.34'
      }.to change(Product, :count).by 0
    end
  end

  describe 'process_record' do
  end

  describe 'update_all' do
  end

end
