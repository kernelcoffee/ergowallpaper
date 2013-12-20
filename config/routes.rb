Ergowallpaper::Application.routes.draw do
  require 'sidekiq/web'

  devise_for :users

  resources :searches

  resources :similitudes do 
    resources :wallpapers
  end

  resources :favorites do 
    resources :wallpapers
  end
 
  resources :users do 
    resources :albums
    resources :wallpapers
    resources :favorites
  end

  resources :wallpapers do
    resources :tags
    member do
      get 'image'
      get 'image_thumb'
    end 
    collection do
      get 'upload'
    end
  end


 resources :albums do 
  resources :wallpapers
  collection do 
    post 'add'
    get 'remove'
  end
 end


  resources :albumassignments do
    resources :wallpapers
    resources :albums
  end

 resources :tags do 
  resources :wallpapers
 end

  # Static pages
  get 'about' => 'home#about', :as => :about
  get 'faq' => 'home#faq', :as => :faq


  namespace :admin do
      authenticate :user, lambda { |u| u.admin? } do
        get '', to: 'dashboard#index', as: '/'
        # get 'admin' => 'dashboard#index', :as => :admin
        resources :users
        resources :wallpapers do
          collection do
            get 'finish_processing'
          end
        end
        resources :aspect_ratios
        resources :settings do
          collection do
            get 'reset_default'
          end
        end
        resources :resolutions do
          collection do
            get 'reset_default'
          end
        end
    end
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'home#index'

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
