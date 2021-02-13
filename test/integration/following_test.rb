require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "should follow user the standard way" do
    @user.unfollow(@other)
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should unfollow user the standard way" do
    @user.unfollow(@other)
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "feed on Home page" do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      # escapeHTML not needed for this next line
      # assert_match CGI.escapeHTML(micropost.user_id.to_s), @user.following_ids.join(', ')
      assert_match CGI.escapeHTML(User.find_by(id: micropost.user_id).name), response.body
    end
  end
  # Now this is where Ajax tests will go one day


end
