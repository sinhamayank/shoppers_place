class CreateTagAndProductRelationships < ActiveRecord::Migration
  def change
    create_table :tag_and_product_relationships do |t|
      t.integer :tag_id
      t.integer :product_id

      t.timestamps
    end
  end
end
