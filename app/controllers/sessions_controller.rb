class SessionsController < ApplicationController
  def new
  end

  def create
      #get params
      #create session based on them
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        #log the user in and redirect to the user's show page
        log_in user
        redirect_to user
      else
        #create error message
        flash.now[:danger] = "Invalid email/password combination' # Not quite right!"
        render 'new'  
      end
  end

  def destroy
    #log_out is in sessions_helper.rb b/c it might be needed elsewhere?
    log_out
    redirect_to root_url
  end


end
