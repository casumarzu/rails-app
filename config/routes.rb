Rails.application.routes.draw do
  scope "(:locale)", locale: /ru|en/ do
    resources :products
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    devise_for :users
    get 'persons/profile'
    root to: redirect("/photos")
    get 'persons/profile', as: 'user_root'
    resources :photos
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
