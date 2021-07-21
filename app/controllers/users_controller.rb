class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "users.index.not_found"
      redirect_to root_path
    end
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "users.show.welcome", name: @user.name
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
