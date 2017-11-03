class Group < ActiveRecord::Base
  has_many :tasks, :through => :group_tasks 

end
