class PasswordResetsController < ApplicationController
  before_action :find_user_by_email, only: %i(create)
  before_action :find_user_by_id, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t ".message.send_email"
    redirect_to root_url
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("password_resets.message.password_blank")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "password_resets.message.success"
      redirect_to @user
    else
      flash[:danger] = t "password_resets.message.fail"
      render :edit
    end
  end

  private

  def find_user_by_email
    @user = User.find_by email: params[:password_reset][:email].downcase
    return if @user&.activated

    flash.now[:danger] = t "password_resets.message.fail"
    render :new
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user&.activated

    flash.now[:danger] = t "password_resets.message.email_wrong"
    render :new
  end

  def valid_user
    return if @user.authenticated? :reset, params[:id]

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_resets.message.expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit User::PASSWORD_RESETS_ATTRIBUTES
  end
end
