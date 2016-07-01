class ActivateAccountMailer < ApplicationMailer
	def activate_account_email(user)
		@user = user
		@url = 'http://localhost:3000/activate_account/' + @user.id.to_s + '?code=' + @user.account_activation_code.code
		mail(to: @user.email, subject: "Welcome to Toodles! - Here's how to get started")
	end

	def activate_account_email_new(user)
		@user = user
		@url = 'http://localhost:3000/activate_account/' + @user.id.to_s + '?code=' + @user.account_activation_code.code
		mail(to: @user.email, subject: "Please activate new email account")
	end
end
