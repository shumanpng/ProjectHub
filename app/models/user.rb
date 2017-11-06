class User < ActiveRecord::Base
    has_many :ActiveUsers
    has_many :tasks
end
