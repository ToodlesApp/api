Rails.application.routes.draw do
  resources :users
  
  post 	'login'							=> 'users#login'
  get 	'activate_account'				=> 'users#activate_account'
  get 	'resend_activation_email/:id'	=> 'users#resend_activation_email'
end
