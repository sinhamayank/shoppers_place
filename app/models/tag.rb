class Tag < ActiveRecord::Base
  has_many :tag_and_product_relationships, dependent: :destroy
  has_many :products, through: :tag_and_product_relationships
end
