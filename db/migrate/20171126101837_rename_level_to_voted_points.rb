class RenameLevelToVotedPoints < ActiveRecord::Migration
  def change
    rename_column :points, :level, :voted_points
  end
end
