require 'logger'

module Omega
  extend self

  def fetch_and_update start_date, end_date
    if json_data = fetch(start_date, end_date)
      update_all json_data
    end
  end

  def fetch start_date, end_date
    params = {api_key: Figs.third_party.omega.api_key,
              start_date: start_date,
              end_date: end_date}
    response = HTTParty.get Figs.third_party.omega.url, params
    if response.status == 200
      JSON.parse response.body
    else
      Rails.logger.error "Connection to Omega Pricing Inc failed, status code: #{response.status}"
      Rails.logger.error "    Response body #{response.body.inspect}"
      false
    end
  end

  def convert_to_pennies(dollar_string)
    dollars = dollar_string.sub(/\$/,'').to_f
    (dollars * 100).round
  end

  def update_product product, record
    price_in_pennies = convert_to_pennies(record['price'])
    if product.price == price_in_pennies
      # do nothing, done
    else
      # log change and update product
      PastPriceRecord.log_change product: product,
                                 new_price: price_in_pennies
      product.update price: price_in_pennies
    end
  end

  def update product, record
    if product.putduct_name == record['name']
      update_product record
    else
      # error name mismatch
      Rails.logger.error "Product has a name mismatch! Internal product id: #{product.id}, name given #{record['name']}"
    end
  end

  def create_new_product record
    product = Product.create external_product_id: record['id'],
                             product_name: record['name'],
                             price: convert_to_pennies(record['price'])
    if product.persisted?
      Rails.logger.info "Created new product called #{product.product_name}, internal id is #{product.id}"
    else
      Rails.logger.error "Problem creating new product, raw data #{record.inspect}"
    end
  end

  def process_record record
    if product = Product.find_by(external_product_id: record['id'])
      update product, record
    else
      # no product found, create unless discontinued
      if record['discontinued'] == false
        create_new_product record
      end
    end
  end

  def update_all json_data
    if json['productRecords']
      json['productRecords'].each do |record|
        process_record record
      end
    else
      Rails.logger.error "Unrecognized data from Omege Pricing Inc"
    end
  end
end
