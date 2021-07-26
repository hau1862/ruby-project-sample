class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception

  include SessionsHelper

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    check = I18n.available_locales.include?(locale)
    I18n.locale = check ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def show_errors_messages messages
    messages.each do |attribute, message|
      flash[:danger] = [attribute.to_s.capitalize, message[0]].join(": ")
    end
  end

  private

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "users.index.login_require"
    store_location
    redirect_to login_path
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path
  end
end
