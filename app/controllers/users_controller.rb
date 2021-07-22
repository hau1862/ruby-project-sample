class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)

  def new
    redirect_to(root_path) if logged_in?
    @user = User.new
  end

  def index
    @users = User.all.page(params[:page]).per Settings.max_item_per_page
  end

  def show; end

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

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update.success"
      redirect_to @user
    else
      flash[:danger] = t ".update.fail"
      show_errors_messages @user.errors.messages
      render :edit
    end
  end

  def destroy
    if current_user.admin
      if @user != current_user && @user.destroy
        flash[:success] = t ".destroy.success"
      else
        flash[:danger] = t ".destroy.fail"
        show_errors_messages @user.errors.messages
      end
    end
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t ".users.index.login_require"
    store_location
    redirect_to login_path
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.index.not_found"
    redirect_to root_path
  end

  def correct_user
    redirect_to(root_path) unless current_user? @user
  end
end
