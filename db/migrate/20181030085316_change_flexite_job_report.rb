class ChangeFlexiteJobReport < ActiveRecord::Migration
  def up
    remove_column :flexite_job_reports, :file_name
    add_column :flexite_job_reports, :stage, :string
    add_column :flexite_job_reports, :checksum, :string
  end

  def down
    add_column :flexite_job_reports, :file_name, :string
    remove_column :flexite_job_reports, :stage
    remove_column :flexite_job_reports, :checksum
  end
end
