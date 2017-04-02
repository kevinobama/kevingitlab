class Admin::DashboardController < Admin::ApplicationController
  def index
    @projects = Project.with_route.limit(10)
    @users = User.limit(10)
    @groups = Group.with_route.limit(10)
  end
end
