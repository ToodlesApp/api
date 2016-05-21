Rails.application.routes.draw do
  resources :users
  
  post 	'login'							=> 'users#login'
  get 	'activate_account'				=> 'users#activate_account'
  get 	'resend_activation_email/:id'	=> 'users#resend_activation_email'
  get 	'forgot_password/:id'			=> 'users#forgot_password'
  get 	'get_new_password'				=> 'users#get_new_password'
  post 	'change_password/:id'			=> 'users#change_password'
end
