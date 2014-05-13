class UsersController < BaseController

  def index
    @users = User.order(:name)
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(15)
  end

end
