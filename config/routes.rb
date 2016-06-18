Rails.application.routes.draw do
  resources :users, only: [:create, :show]

  post 	'validate_credentials'         => 'users#validate_credentials'
  get 	'activate_account/:id'         => 'users#activate_account'
  get 	'resend_activation_email/:id'  => 'users#resend_activation_email'
  get 	'forgot_password/:id'          => 'users#forgot_password'
  get 	'get_new_password/:id'         => 'users#get_new_password'
  put 	'change_password/:id'          => 'users#change_password'
  put 	'change_info/:id'              => 'users#change_info'
  put 	'change_email/:id'             => 'users#change_email'

end
