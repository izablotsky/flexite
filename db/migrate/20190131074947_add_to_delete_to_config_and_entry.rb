class AddToDeleteToConfigAndEntry < ActiveRecord::Migration
  def change
    add_column :flexite_configs, :to_delete, :boolean, allow_nil: false, default: false
    add_column :flexite_entries, :to_delete, :boolean, allow_nil: false, default: false
  end
end
