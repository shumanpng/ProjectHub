class UserLoginValidation < ActiveModel::Validator
    def validate(record)
        user = User.where('email = (?) AND password =  (?)', record.email, record.password).take
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