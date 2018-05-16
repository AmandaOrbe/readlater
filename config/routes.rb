Rails.application.routes.draw do
 get 'pages/home'
  get 'pages/about'
  devise_for :users,
  controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  get 'articles', to: "articles#index"
  get 'articles/new', to: "articles#new"
  post 'articles', to: "articles#create"
  get 'articles/:id/edit', to: "articles#edit"
  patch 'articles/id', to: "articles#update"
  delete 'articles/id', to: "articles#destroy", as: "article/delete"

  get 'categories/new', to: "categories#new"
  get 'categories/new_article', to: "categories#new_article", as: "new_article"
  get 'categories/:id', to: "categories#show",  as: "category"
  post 'categories', to: "categories#create"
  get 'categories/:id/edit', to: "categories#edit", as: "category/edit"
  patch 'categories/:id', to: "categories#update", as: "category/update"
  delete 'categories/id', to: "categories#destroy", as: "category/delete"

  authenticated :user do
    root 'articles#index', as: :authenticated_root
  end

  root to: "pages#home"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
