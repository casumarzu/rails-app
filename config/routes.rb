Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  get 'persons/profile'

  root 'photos#index'
  get 'persons/profile', as: 'user_root'
  resources :photos
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
