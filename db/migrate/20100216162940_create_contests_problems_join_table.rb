class CreateContestsProblemsJoinTable < ActiveRecord::Migration[4.2]
  def self.up
    create_table :contests_problems, :id => false do |t|
      t.integer :contest_id
      t.integer :problem_id
    end
  end

  def self.down
    drop_table :contests_problems
  end
end
