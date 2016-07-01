class ForgotPasswordMailer < ApplicationMailer
  def forgot_password_email(user)
  	@user = user
  	@url = 'http://localhost:3000/get_new_password/' + @user.id.to_s + '?code=' + @user.password_digest
  	mail(to: @user.email, subject: "Toodles - Reset Password Requested")
  end
end
