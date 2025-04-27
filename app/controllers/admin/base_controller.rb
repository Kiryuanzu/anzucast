class Admin::BaseController < ApplicationController
  before_action :require_admin_login

  private

  def require_admin_login
    unless logged_in?
      flash[:alert] = "ログインしてください"
      redirect_to admin_login_path
    end
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
