class ChangeFlexiteDiff < ActiveRecord::Migration
  def up
    rename_column :flexite_diffs, :checksum, :version
  end

  def down
    rename_column :flexite_diffs, :version, :checksum
  end
end
