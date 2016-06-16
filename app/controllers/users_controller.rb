class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :resend_activation_email, :change_password, :forgot_password]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      ActivateAccountMailer.activate_account_email(@user).deliver_now!
      render json: {created: true, details: @user}
    else
      render json: {created: false, details: @user.errors}
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: {updated: true, details: @user}
    else
      render json: {updated: false, details: @user.errors}
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # POST /validate_credentials
  def validate_credentials
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      render json: {valid: true, details: @user}
    else
      render json: {valid: false, details: "Invalid username/password combination"}
    end
  end

  # GET /activate_account
  def activate_account
    user = User.find_by(username: params[:username])
    if !user
      render json: {activated: false, details: "Invalid username"}
    elsif user.is_activated
      render json: {activated: false, details: "Account already activated"}
    elsif !user.activate(params[:code])
      render json: {activated: false, details: "Unable to activate"}
    else
      render json: {activated: true, details: "Success"}
    end
  end

  # GET /resend_activation_email/1
  def resend_activation_email
    if @user.is_activated
      render json: {sent_email: false, details: "Account already activated"}
    else
      ActivateAccountMailer.activate_account_email(@user).deliver_later
      render json: {sent_email: true, details: "Success"}
    end
  end

  # GET /forgot_password/1
  def forgot_password
    if @user
      ForgotPasswordMailer.forgot_password_email(@user).deliver
      render json: {sent_email: true, details: "Success"}
    else
      render json: {sent_email: false, details: "Unable to find user"}
    end
  end

  # GET /get_new_password
  def get_new_password
    user = User.find_by(username: params[:username])
    if user && user.password_digest == params[:code]
      random_password = SecureRandom.hex(4)
      user.password = random_password
      user.password_confirmation = random_password
      if user.save
        render json: {password_generated: true, details: random_password}
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      render json: {valid: false, details: "Invalid username/code"}
    end

  end

  # POST /change_password/1
  def change_password
    if !@user.authenticate(params[:password])
      render json: {updated: false, details: "Invalid password"}
    else
      @user.password = params[:new_password]
      @user.password_confirmation = params[:new_password_confirmation]
      if @user.save
        render json: {updated: true , details: @user}
      else
        render json: {updated: false, details: @user.errors}
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation)
    end
end
