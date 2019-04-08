class AddUpdatedByToFlexiteConfig < ActiveRecord::Migration
  def change
    add_column :flexite_configs, :updated_by, :string
  end
end
