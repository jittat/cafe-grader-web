class CreateCountries < ActiveRecord::Migration[4.2]
  def self.up
    create_table :countries do |t|
      t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :countries
  end
end
