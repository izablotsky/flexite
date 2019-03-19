class RenameFlexiteJobReportChecksumColumn < ActiveRecord::Migration
  def up
    rename_column :flexite_job_reports, :checksum, :version
  end

  def down
    rename_column :flexite_job_reports, :version, :checksum
  end
end
