class Category < ActiveRecord::Base
  has_many :category_and_product_relationships, dependent: :destroy
  has_many :products, through: :category_and_product_relationships
end
