class AddDeadlineToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :deadline, :date
  end
end
