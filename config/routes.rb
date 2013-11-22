Crp::Application.routes.draw do
  scope "(/:locale)" do
    resources :sales, :sale_receipts, :sale_items
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
    resources :stores, :roles, :user_roles, :units, :product_types, :product_categories, :vat_rates do
      patch 'batch_destroy', on: :collection
      get 'import', on: :collection
    end
    post 'session/records_per_page' => 'session#records_per_page'
    
    get "demo/index"
    get "demo/hashes"
  end
  get '/:locale' => 'dashboard#index'
  root to: 'dashboard#index'

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
