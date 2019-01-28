class AddLockedToEnvToFlexiteEntry < ActiveRecord::Migration
  def change
    add_column :flexite_entries, :locked_to_env, :boolean, allow_nil: false, default: false
  end
end
