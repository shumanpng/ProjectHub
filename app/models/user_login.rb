class UserLoginValidation < ActiveModel::Validator
    def validate(record)
        require 'digest'
        md5 = Digest::MD5.new
        password = md5.hexdigest record.password
        user = User.where('email = (?) AND password =  (?)', record.email, password).take
        if user == nil
            record.errors[:base] << "Invalid Credentials"
        end
    end
end

class UserLogin < ActiveRecord::Base
    validates_with UserLoginValidation
end



# check to see if the email address exsists
# check to see if the passsword exists
# if they both match and exist to the same user create a userlogin.