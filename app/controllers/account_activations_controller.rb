class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      activate_user user
      redirect_to user
    else
      show_errors_messages user.errors.messages
      flash[:danger] = t "auths.mail.active.fail"
      redirect_to root_url
    end
  end

  private

  def activate_user user
    user.activate
    log_in user
    flash[:success] = t ".auths.mail.activate.success"
  end
end
