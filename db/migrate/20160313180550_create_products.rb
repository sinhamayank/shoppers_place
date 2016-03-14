class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.date :expire_date
      t.integer :sku_id
      t.integer :price
      t.integer :array_of_tag_ids, array: true, default: []
      t.integer :array_of_category_ids, array: true, default: []
      t.string :prod_id

      t.timestamps
    end
    add_index :products, :prod_id, :unique => true
    add_index :products, :sku_id, :unique => true
  end
end
