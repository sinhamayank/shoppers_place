Rails.application.routes.draw do

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      post 'products', to: 'vendor#create_product'
      put 'products', to: 'vendor#update_product'
    end
  end
  
  namespace :host do
    namespace :admin do
      resources :products, only: [:index, :show, :edit, :update]
    end
  end
  
  get '/', to: redirect('host/admin/products')
  
end
