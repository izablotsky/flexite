class AddUpdatedByToEntry < ActiveRecord::Migration
  def change
    add_column :flexite_entries, :updated_by, :string
    add_column :flexite_history_attributes, :updated_by, :string
  end
end
