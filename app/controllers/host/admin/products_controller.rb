class Host::Admin::ProductsController < ApplicationController
  #TODO Add flash messages
  
  def index
    begin
      @products = Product.includes( :images ).select( [:name, :sku_id, :id, :price] )
    rescue
      #TODO error logging
    end
  end
  
  def show
    begin
      @product = Product.includes( :images ).find( params[:id] )
      tag_ids = @product.array_of_tag_ids
      @tags = Product.get_array_of_record_names_from_ids( tag_ids, true) #from tag_ids, this functions fetches all the tags in an array, second arguement tells if it's tag ids or category ids
      category_ids = @product.array_of_category_ids
      @categories = Product.get_array_of_record_names_from_ids( category_ids, false) #from category_ids, this functions fetches all the categories in an array, second arguement tells if it's tag ids or category ids
    rescue
      #TODO error logging
    end      
  end

  def edit
    begin
      @product = Product.find( params[:id] )
      #Making comma separated string of existing tags and categories respectively
      tag_ids = @product.array_of_tag_ids
      @tags = Product.get_comma_sep_str_from_array( tag_ids, true ) #from tag_ids, this functions fetches all the tags in an array, second arguement tells if it's tag ids or category ids
      category_ids = @product.array_of_category_ids
      @categories = Product.get_comma_sep_str_from_array( category_ids, false ) #from category_ids, this functions fetches all the categories in an array, second arguement tells if it's tag ids or category ids
    rescue
      #TODO error logging
    end      
  end

  def update
    begin
      @product = Product.find( params[:id] )
      @tags = params[:tags].split(",") #generating tags array from received tags comma separated string
      @categories = params[:categories].split(",") #generating categories array from received categories comma separated string
      Product.update_product( @tags, @categories, @product.sku_id, params[:name], params[:price], params[:expire_date] )
      redirect_to host_admin_product_path(params[:id])
    rescue
      #TODO error logging
    end
  end
  
end
