class AddLockedToConfig < ActiveRecord::Migration
  def up
    remove_column :flexite_entries, :locked_to_env
    add_column :flexite_configs, :locked, :boolean, allow_nil: false, default: false
  end

  def down
    add_column :flexite_entries, :locked_to_env, :boolean, allow_nil: false, default: false
    remove_column :flexite_configs, :locked
  end
end
