Hitchlog::Application.routes.draw do
  devise_for :users, :path_names => { :sign_in => 'login' },
                     path: 'hitchhikers',
                     :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  filter :locale

  # omniauth:
  match '/auth/:provider/callback' => 'authentications#create'  

  resources :users, :path => 'hitchhikers' do
    member do 
      get :send_mail
      post :mail_sent
    end
  end

  resources :trips do
    resources :rides, :except => [:index]
    member do
      post :create_comment
    end
  end
  
  resources :rides, :except => [:index] do
    collection do
      get    :random
    end
    member do
      get    :next
      get    :prev
      delete :delete_photo
    end
  end
  
  match 'hitchhikers' => 'users#index'
  match 'about' => 'welcome#about'

  root :to => "welcome#home"
end
