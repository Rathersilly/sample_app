class ApplicationController < ActionController::Base
    include SessionsHelper
    def hello
        render plain: "Hello There"
    end
end
