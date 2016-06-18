Crp::Application.routes.draw do
  scope "(/:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, :controllers => { :registrations => "registrations" }
    devise_scope :user do
       get "registrations/confirmation" => 'registrations#confirmation'
       get "users/change_store/:store_id" => 'users#change_store', as: :change_store
    end
    
    scope '/admin' do
      resources :users do
        patch 'batch_destroy', on: :collection
      end
    end
    resources :database_resets, except: [:new, :edit]
    resources :stores, :roles, :user_roles, :units, :product_categories, :vat_rates, :products, :services, :stockables, :product_prices, :product_aliases, :sales, :sale_receipts, :sale_items, :takings do
      patch 'batch_destroy', on: :collection
      get 'import', on: :collection
      post 'upload', on: :collection
    end
    
    get 'unrecognized_products' => 'sales#unrecognized_products', as: :unrecognized_products
    get 'reset_database' => 'database_resets#do_reset', as: :reset_database
    get 'example_file/:store_id/:filename' => 'sales#example_file', as: :example_file
    
    get 'session/per_page' => 'session#per_page', as: :per_page
    post 'session/per_page' => 'session#update_per_page', as: :update_per_page
    
    get "demo/index"
    get "demo/hashes"
    get 'demo/blocks'
    
  end
  root to: 'dashboard#index'
  get '/:locale' => 'dashboard#index', as: :locale_root

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
