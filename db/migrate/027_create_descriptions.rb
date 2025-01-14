class CreateDescriptions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :descriptions do |t|
      t.column :body, :text
      t.column :markdowned, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :descriptions
  end
end
