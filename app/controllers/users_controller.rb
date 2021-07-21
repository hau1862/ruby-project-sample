class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.index.not_found"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "users.show.welcome", name: @user.name
      session[:user_id] = @user.id
      redirect_to @user
    else
      show_errors_messages @user.errors.messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end
end
