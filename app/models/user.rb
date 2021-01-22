class User < ApplicationRecord
    before_save { self.email.downcase!}  
        # also { self.email = email.downcase}   
        # which is same as before_save { self.email = self.email.downcase}
        # ie implicit self.  BUT implicit self cant be used on left side of assignment
    validates :name, presence: true, length: { maximum: 50 }
        # same as validates(:name, presence: true)
    VALID_EMAIL_REGEX = /\A[\w\-.\+]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                            format: { with: VALID_EMAIL_REGEX },
                            uniqueness: { case_sensitive: false }

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }

end
