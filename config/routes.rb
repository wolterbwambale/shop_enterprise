Rails.application.routes.draw do
  resources :outlet_types
  resources :product_units
  resources :company_infos
  resources :departments
  resources :product_details
  resources :company_details, except: [:index]
  resources :categories
  resources :orders do
    member do
      get :receipt
    end
  end

  resources :stock_records, only: [:index] do
    collection do
      get :company_stock_records
    end
  end

  resources :products do
    collection do
      get 'select_for_issue'
      post 'issue_multiple'
      get 'issue_multiple'
      get 'issued_products_summary'
      get 'product_detailed_summary'
      get 'issued_products'
      get :company_products
      get 'goods_received', to: 'products#goods_received'
      get :damage_goods_index
      get 'general_report'
    end

    member do
      post 'restock'
      patch 'transfer'
      patch 'issue'
      get 'issued_products'
      get'receive_goods'
      post :receive_goods
      get 'goods_received'
      patch 'damage_goods'
      get 'damaged_goods'
      post 'damage_goods'
    end
  end
  
  get 'stock_periods_products', to: 'products#stock_periods', as: 'stock_periods_products'
  get 'issued_products_summary', to: 'products#issued_products_summary', as: 'issued_products_summary'
  get 'product_detailed_summary', to: 'products#product_detailed_summary', as: 'product_detailed_summary'
  get '/company_products', to: 'products#company_products', as: 'company_products'
  get '/damage_goods', to: 'products#damage_goods_index', as: 'damage_goods_index'


  
  # root "products#index"
  root 'orders#new'
end
