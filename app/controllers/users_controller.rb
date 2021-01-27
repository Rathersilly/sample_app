class UsersController < ApplicationController
  def new
    @user = User.new
    #debugger
  end

  def create
    @user = User.new(user_params) #not the final implementation!
    
    if @user.save
      log_in @user
      # handle a successful save.
      flash[:success] = "Welcome to the Sample App!"
      
      redirect_to @user
      # same as redirect_to user_url(@user)
    else
      render 'new'
    end

    
  end


  def show
    @user = User.find(params[:id])
    #debugger
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
