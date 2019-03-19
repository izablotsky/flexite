class AddPathToConfigAndEntry < ActiveRecord::Migration
  def change
    add_column :flexite_configs, :path, :string
    add_column :flexite_entries, :path, :string
  end
end
