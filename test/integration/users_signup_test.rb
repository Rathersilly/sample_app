require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  


  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }                                    
    end 
    #debugger
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'form[action="/signup"]'
  end

  test "valid signup information" do
    assert_difference 'User.count' do
      post signup_path, params: { user: { name: "Test Testerson",
                                        email: "test@asdf.com",
                                        password: "asdfasdf",
                                        password_confirmation: "asdfasdf" } }
    end
    follow_redirect!
    assert_template 'users/show'               
    # these all work to test flash:
    #assert_select 'div.alert-success'
    #assert !flash[:success].nil?
    assert flash[:success]
    assert is_logged_in?
  end

  

end
