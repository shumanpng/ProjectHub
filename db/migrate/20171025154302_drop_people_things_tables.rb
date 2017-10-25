class DropPeopleThingsTables < ActiveRecord::Migration
  def up
    drop_table :people
    drop_table :things
  end

  def down
    create_table :people
    create_table :things
  end
end
