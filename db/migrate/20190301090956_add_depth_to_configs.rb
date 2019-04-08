class AddDepthToConfigs < ActiveRecord::Migration
  def change
    add_column :flexite_configs, :depth, :integer, default: 0
  end
end
