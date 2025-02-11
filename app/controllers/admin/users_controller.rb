class Admin::UsersController < AdminController
  before_action :get_users, except: [:index, :new, :create]

  def index
    @users = User.search(params)
      .order_name 
      .paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html
        format.xls { send_data @users.to_xls(col_sep: "\t") } 
      end
  end 

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Create User successfully"
      redirect_to admin_users_path
    else
      flash[:warning] = "Create User failed"
      render :new
    end
  end

  def edit
  end

  def show
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "Updated user successfully"
      redirect_to admin_users_path
    else
      flash[:warning] = "Update user failed"
      redirect_to admin_users_path
    end
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
        :password_confirmation, :is_admin)
    end
    
    def get_users
      @user = User.find_by_id(params[:id])
      return if @user.present?
      flash[:warning] = "That publisher could not be found"
      redirect_to admin_users_path  
    end

end