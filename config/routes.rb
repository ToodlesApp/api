Rails.application.routes.draw do
  resources :users
  
  post 	'login'						=> 'users#login'
  post 	'validate_email'			=> 'users#validate_email'
end
