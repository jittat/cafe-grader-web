class CreateContestsUsersJoinTable < ActiveRecord::Migration[4.2]
  def self.up
    create_table :contests_users, :id => false do |t|
      t.integer :contest_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :contests_users
  end
end
