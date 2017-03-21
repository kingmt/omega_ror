class PastPriceRecord < ApplicationRecord
  belongs_to :product

  validates :price, :percentage_change, presence: true

  def self.log_change args
    current_price = args[:product].price
    create product: args[:product],
           price: current_price,
           percentage_change: find_percentage_change(current_price, args[:new_price])
  end

  def self.find_percentage_change old_price, new_price
    delta = new_price - old_price
    percentage_change = delta / (old_price * 1.0)
    percentage_change.round 2
  end
end
