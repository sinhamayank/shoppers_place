class CreateCategoryAndProductRelationships < ActiveRecord::Migration
  def change
    create_table :category_and_product_relationships do |t|
      t.integer :product_id
      t.integer :category_id

      t.timestamps
    end
  end
end
