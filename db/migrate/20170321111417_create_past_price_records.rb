class CreatePastPriceRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :past_price_records do |t|
      t.references :product, foreign_key: true
      t.integer :price
      t.float :percentage_change

      t.timestamps
    end
  end
end
