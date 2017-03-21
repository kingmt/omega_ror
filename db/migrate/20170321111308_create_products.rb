class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :external_product_id
      t.integer :price
      t.string :product_name

      t.timestamps
    end
  end
end
