class ApplicationController < ActionController::Base
    def hello
        render plain: "Hello There"
    end
end
