class SessionsController < ApplicationController
  # curl -XPOST -v -H 'Content-Type: application/json' -H 'Accept:application/json' http://localhost:3000/login -d '{"session": { "email": "asdf@example.com", "password": "asdfasdf" } } ' -c cookie.txt
  # this line will let you log in from curl:
  # skip_before_action :verify_authenticity_token
  def new
  end

  def create
      #get params
      #create session based on them
      @user = User.find_by(email: params[:session][:email].downcase)
      if @user && @user.authenticate(params[:session][:password])
        #log the user in and redirect to the user's show page
        
        if @user.activated?
          log_in @user
          # remember user
          params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
          redirect_back_or @user
        else
          message = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:warning] = message
          redirect_to root_url
        end
      else
        #create error message
        # flash lasts for one request. render isn't a request, so
        # flash.now is what we use instead
        flash.now[:danger] = "Invalid email/password combination' # Not quite right!"
        render 'new'  
      end
  end

  def destroy
    #log_out is in sessions_helper.rb b/c it might be needed elsewhere?
    log_out if logged_in?
    redirect_to root_url
  end


end
