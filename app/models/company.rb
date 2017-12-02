class Company < ActiveRecord::Base
    has_many :users

    validates :name, :presence => true
    validates :description, :length => { :maximum => 140 }
end
