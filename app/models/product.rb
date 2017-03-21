class Product < ApplicationRecord
  validates :external_product_id, :product_name, :price, presence: true
end
