class Product < ActiveRecord::Base
  validates :name, :sku_id, :price, :presence => true
  
  has_many :images, -> { order('created_at') }, dependent: :destroy
  has_many :tag_and_product_relationships, dependent: :destroy
  has_many :tags, through: :tag_and_product_relationships
  has_many :category_and_product_relationships, dependent: :destroy
  has_many :categories, through: :category_and_product_relationships 
  
  #Purpose: create product, its images; tags and categories
  def self.create_product( expire_date, name, sku_id, price, images, tags, categories )
    begin
      expire_date = self.convert_date_string_to_date( expire_date )
      @product = self.create!( expire_date: expire_date, name: name, sku_id: sku_id, price: price, prod_id: self.generate_prod_id )
      images.each do |image|
        @product.images.create!( url: image["img_path"] )
      end if !images.blank?
      @tag_ids = self.save_new_tags_and_return_tag_ids_array( tags, true ) #checks and creates tags if not already present along with relationship creation and returns an array of product tag ids, second parameter tells if the request is for create product
      @category_ids = save_new_catg_and_return_catg_ids_array( categories, true ) #checks and creates categories if not already present along with relationship creation and returns an array of product category ids, second parameter tells if the request is for create product
      @product.update!( array_of_tag_ids: @tag_ids.sort, array_of_category_ids: @category_ids.sort )
    rescue
      #TODO rollback and error logging
    end
  end
  
  #Purpose: update product, its tags and categories
  def self.update_product( tags, categories, sku_id, name, price, expire_date )
    begin
      product = self.find_by_sku_id( sku_id )
      tag_ids = self.save_new_tags_and_return_tag_ids_array( tags, false ) #checks and creates tags if not already present and returns an array of product tag ids, second parameter tells if the request is for create product
      del_previous_create_new_relationship( product, tag_ids, true ) if product.array_of_tag_ids != tag_ids.sort  #call if tags have been changed, second parameter in the function tells if it is a request for tag and product relationship
      category_ids = save_new_catg_and_return_catg_ids_array( categories, false ) #checks and creates categories if not already present and returns an array of product category ids, second parameter tells if the request is for create product
      del_previous_create_new_relationship( product, category_ids, false ) if product.array_of_category_ids != category_ids.sort #call if categories have been changed, second parameter in the function tells if it is a request for tag and product relationship
      expire_date = Date.strptime( expire_date, "%Y-%m-%d" )  
      product.update( name: name, price: price, array_of_tag_ids: tag_ids, array_of_category_ids: category_ids, expire_date: expire_date )
    rescue
      #TODO rollback and error logging
    end
  end
  
  private
  
  #Purpose: generate unique product id
  def self.generate_prod_id
    begin
      prod_id = SecureRandom.hex(n=4)
      prod_id = prod_id.to_s.downcase
    end while self.find_by_prod_id( prod_id )
    return prod_id
  end  

  #Purpose: from a given array, generate and return a comma separated string
  def self.get_comma_sep_str_from_array( ids, is_tag )
    comma_sep_str = ""
    if is_tag
      ids.each do |id|
        comma_sep_str = comma_sep_str + "," + Tag.find(id).tag_name
      end
    else
      ids.each do |id|
        comma_sep_str = comma_sep_str + "," + Category.find(id).category_name
      end      
    end
    comma_sep_str[1..comma_sep_str.length]    
  end
  
  #Purpose: from an array of record ids, generate and return an array of record names
  def self.get_array_of_record_names_from_ids( ids, is_tag)
    array_of_record_names = Array.new
    if is_tag
      ids.each do |id|
        array_of_record_names << Tag.find(id).tag_name
      end
    else
      ids.each do |id|
        array_of_record_names << Category.find(id).category_name
      end      
    end
    array_of_record_names 
  end  
  
  #Purpose: save tags if not already present; also create tag-prod relationship if product is being created and not updated
  def self.save_new_tags_and_return_tag_ids_array( tags, is_product_create )
    begin
      tag_ids = Array.new
      tags.each do |tag|
        @tag = Tag.find_by_tag_name( tag.downcase )
        if !@tag.blank?
          @id = @tag.id
          @product.tag_and_product_relationships.create!( tag_id: @id ) if is_product_create #creating relationship if the request is for product creation
        else
          @tag = Tag.create!( tag_name: tag.downcase )
          @id = @tag.id
          @product.tag_and_product_relationships.create!( tag_id: @id ) if is_product_create #creating relationship if the request is for product creation
        end
        tag_ids << @id      
      end if !tags.blank?
      tag_ids
    rescue
      #TODO rollback and error logging
    end
  end  
  
  #Purpose: save categories if not already present; also create catg-prod relationship if product is being created and not updated
  def self.save_new_catg_and_return_catg_ids_array( categories, is_product_create )
    begin
      category_ids = Array.new
      categories.each do |category|
        @category = Category.find_by_category_name( category.downcase )
        if !@category.blank?
          @id = @category.id
          @product.category_and_product_relationships.create!( category_id: @id ) if is_product_create #creating relationship if the request is for product creation
        else
          @category = Category.create!( category_name: category.downcase )
          @id = @category.id
          @product.category_and_product_relationships.create!( category_id: @id ) if is_product_create #creating relationship if the request is for product creation
        end
        category_ids << @id      
      end if !categories.blank?
      category_ids
    rescue
      #TODO rollback and error logging
    end
  end    
  
  #Purpose: delete old product tags/categories relationships and create new
  def self.del_previous_create_new_relationship( product, ids, is_tag )
    begin
      if is_tag
        product.tag_and_product_relationships.delete_all
        ids.each do |id|
          product.tag_and_product_relationships.create!( tag_id: id )
        end if !ids.blank?      
      else
        product.category_and_product_relationships.delete_all
        ids.each do |id|
          product.category_and_product_relationships.create!( category_id: id )
        end if !ids.blank?      
      end
    rescue
      #TODO rollback and error logging
    end    
  end
  
  def self.convert_date_string_to_date( expire_date )
    expire_date = Date.strptime( expire_date, "%Y-%m-%d" )
  end
  
end
