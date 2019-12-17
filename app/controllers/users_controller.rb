class UsersController<ApplicationController
  def new
    @new_user = User.new(user_params)
  end

  def create
    new_user = User.new(user_params)
    if new_user.save
      flash[:success] = "Congratulations! You are now registered and logged in."
      session[:user_id] = new_user.id
      redirect_to "/profile"
    else
      flash[:error] = new_user.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

  def new_params
      params.permit(:name, :address, :city, :state, :zip)
  end
end
