class SessionsController < ApplicationController
  def new
    redirect_to show_path(current_user.id) if logged_in?
  end

  def create
    user = User.find_by email: params[:sessions][:email].downcase

    if user&.authenticate params[:sessions][:password]
      flash[:success] = t "sessions.message.login_success"
      log_in user
      redirect_to user
    else
      flash[:danger] = t "sessions.message.login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
