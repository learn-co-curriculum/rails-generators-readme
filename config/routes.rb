Rails.application.routes.draw do
  resources :accounts
  get 'accounts/new'

  get 'accounts/create'

  get 'accounts/edit'

  get 'accounts/update'

  get 'accounts/destroy'

  get 'accounts/index'

  get 'accounts/show'

  get 'admin/dashboard'

  get 'admin/stats'

  get 'admin/financials'

  get 'admin/settings'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'categories/show'

  resources :posts, only: [:index, :show, :new, :create, :edit, :update]
  resources :categories
end
