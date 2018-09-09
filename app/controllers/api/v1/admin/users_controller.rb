class Api::V1::Admin::UsersController < Api::V1Controller

  before_action :is_admin?
  before_action :find_user, except: [ :index, :create ]

  def index
    @users = current_resource_owner.company.users.sort

    render :index
  end

  def create
    @user = current_resource_owner.company.users.new(user_params)

    if @user.save
      render :show
    else
      render_response(success: false, errors: @user.errors, status: 200)
    end
  end

  def update
    if @user.update(user_params)
      render :show
    else
      render_response(success: false, errors: @user.errors, status: 200)
    end
  end

  def show
    render :show
  end

  private

    def user_params
      params.permit(:email, :password, :password_confirmation)
    end

    def find_user
      @user = current_resource_owner.company.users.find(params[:id])
    end

end
