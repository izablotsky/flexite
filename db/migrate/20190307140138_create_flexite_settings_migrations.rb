class CreateFlexiteSettingsMigrations < ActiveRecord::Migration
  def change
    create_table :flexite_settings_migrations do |t|
      t.string :version

      t.timestamps
    end

    add_index :flexite_settings_migrations, :version, unique: true
  end
end
