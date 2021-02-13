class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # leaving ajax for now
    #respond_to do |format|
    #  #format.html { redirect_to @user }
    #  format.js #{ render layout: false, content_type: 'text/javascript'}
    #end
    redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    #respond_to do |format|
      #format.html { redirect_to @user }
      #format.js #{ render layout: false, content_type: 'text/javascript'}
    #end
    redirect_to @user
  end

end
