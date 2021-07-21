class SessionsController < ApplicationController
  def new
    redirect_to current_user if logged_in?
  end

  def create
    remember_value = params[:sessions][:remember_me]
    user = User.find_by email: params[:sessions][:email].downcase

    if user&.authenticate params[:sessions][:password]
      login_user user, remember_value
      redirect_to user
    else
      flash[:danger] = t "sessions.message.login_fail"
      render :new
    end
  end

  def destroy
    if logged_in?
      forget current_user
      log_out
    end
    redirect_to root_path
  end

  def login_user user, remember_value
    flash[:success] = t "sessions.message.login_success"
    log_in user
    remember_value == "1" ? remember(user) : forget(user)
  end
end
