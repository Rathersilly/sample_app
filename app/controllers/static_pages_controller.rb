class StaticPagesController < ApplicationController
  def home
    # flash[:wtf] = 'WTF ' * 10
    # flash[:success] = "HIHIHHI"
    @micropost = current_user.microposts.build if logged_in?
  end

  def help; end

  def about; end

  def contact; end
end
