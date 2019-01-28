class CreateFlexiteDiff < ActiveRecord::Migration
  def change
    create_table :flexite_diffs do |t|
      t.string :stage
      t.string :checksum
      t.string :change_type
      t.text   :path
      t.text   :hash_changes
    end
  end
end
