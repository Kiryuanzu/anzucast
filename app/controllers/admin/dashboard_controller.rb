class Admin::DashboardController < Admin::BaseController
  def index
    # This will be protected by the require_admin_login before_action
  end
end
