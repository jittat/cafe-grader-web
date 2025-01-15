class CreateProblems < ActiveRecord::Migration[4.2]
  def self.up
    create_table :problems do |t|
      t.column :name, :string, :limit => 30
      t.column :full_name, :string
      t.column :full_score, :integer
      t.column :date_added, :date
      t.column :available, :boolean
    end
  end

  def self.down
    drop_table :problems
  end
end
