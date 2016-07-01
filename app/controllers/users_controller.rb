class UsersController < ApplicationController
  before_action :set_user, only: [:show, :activate_account, :change_info, :change_email,
    :resend_activation_email, :change_password, :forgot_password]

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(create_params)
    if @user.save
      ActivateAccountMailer.activate_account_email(@user).deliver_later
      render json: {success: true, details: @user}
    else
      render json: {success: false, details: @user.errors}
    end
  end

  # POST /validate_credentials
  def validate_credentials
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      render json: {success: true, details: @user}
    else
      render json: {success: false, details: "Invalid email/password combination"}
    end
  end

  # GET /activate_account/1
  def activate_account
    if @user.is_activated
      render json: {success: false, details: "Account already activated"}
    elsif !@user.activate(params[:code])
      render json: {success: false, details: "Unable to activate"}
    else
      render json: {success: true, details: "Success"}
    end
  end

  # GET /resend_activation_email/1
  def resend_activation_email
    if @user.is_activated
      render json: {success: false, details: "Account already activated"}
    else
      ActivateAccountMailer.activate_account_email(@user).deliver_later
      render json: {success: true, details: "Success"}
    end
  end

  # GET /forgot_password/1
  def forgot_password
    if @user
      ForgotPasswordMailer.forgot_password_email(@user).deliver_later!
      render json: {success: true, details: "Success"}
    else
      render json: {success: false, details: "Unable to find user"}
    end
  end

  # GET /get_new_password/1
  def get_new_password
    if @user.password_digest == params[:code]
      random_password = SecureRandom.hex(4)
      @user.password = random_password
      @user.password_confirmation = random_password
      if @user.save
        render json: {success: true, details: random_password}
      else
        render json: {success: false, details: @user.errors}
      end
    else
      render json: {success: false, details: "Invalid code"}
    end
  end

  # PUT /change_password/1
  def change_password
    if !@user.authenticate(params[:password])
      render json: {success: false, details: "Invalid password"}
    else
      @user.password = params[:new_password]
      @user.password_confirmation = params[:new_password_confirmation]
      if @user.save
        render json: {success: true , details: @user}
      else
        render json: {success: false, details: @user.errors}
      end
    end
  end

  # PUT /change_info/1
  def change_info
      old_email = @user.email
      if @user.update(change_info_params)
        if change_info_params[:email] == old_email
          render json: {success: true, details: @user, email_changed: false}
        else
          @user.create_activation_code
          ActivateAccountMailer.activate_account_email_new(@user).deliver_now!
          render json: {success: true, details: @user, email_changed: true}
        end
      else
        render json: {success: false, details: @user.errors}
      end
  end

  # PUT /change_email/1
  def change_email
      if change_email_params[:email] == @user.email
        render json: {success: false, details: "Email didn't change"}
      elsif @user.update(change_email_params)
        @user.create_activation_code
        ActivateAccountMailer.activate_account_email_new(@user).deliver_now!
        render json: {success: true, details: @user}
      else
        render json: {success: false, details: @user.errors}
      end
  end

  private
    def set_user
      @user = User.find_by(id: params[:id])
      if !@user
        render json: {success: false, details: "Unable to find user account"}
      end
    end

    def create_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def change_info_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end

    def change_email_params
      params.require(:user).permit(:email)
    end
end
