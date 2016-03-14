class Api::V1::VendorController < ApplicationController
  
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  
  def create_product
    begin
      Product.create_product( params[:expire_date], params[:name], params[:sku_id], params[:price], params[:images], params[:tags], params[:categories] )
      respond_to do |format|
        #TODO using serializers, send the created product information
        format.json { render :json => { :success => true, :status => 200 } }
      end  
    rescue Exception => e
      respond_to do |format|
        logger.error "There was some code error in vendor#create_product. " + e.message + " " + Time.zone.now.strftime("%H:%M:%S - %d/%m/%Y").to_s
        format.json { render :json => { :success => false, :user_message => "Please try again later.", :status => 500 } }
      end      
    end 
  end
  
  #ASSUMPTIONS
  #(1) sku_id will nevel change once a product is created and it is unique
  #(2) images can't be updated once a product is added
  def update_product
    begin
      Product.update_product( params[:tags], params[:categories], params[:sku_id], params[:name], params[:price], params[:expire_date] )
      respond_to do |format|
        #TODO using serializers, send the updated product information
        format.json { render :json => { :success => true, :status => 200 } }
      end
    rescue Exception => e
      respond_to do |format|
        logger.error "There was some code error in vendor#update_product. " + e.message + " " + Time.zone.now.strftime("%H:%M:%S - %d/%m/%Y").to_s
        format.json { render :json => { :success => false, :user_message => "Please try again later.", :status => 500 } }
      end      
    end     
  end
end
