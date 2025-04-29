class Admin::SessionsController < Admin::BaseController
  skip_before_action :require_admin_login, only: [ :new, :create ]

  def new
    # renders the login form
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_episodes_path, notice: "ログインしました"
    else
      flash.now[:alert] = "パスワードが違っています"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to admin_login_path, notice: "ログアウトしました"
  end
end
