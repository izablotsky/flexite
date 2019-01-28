ShowDiffJob = Struct.new(:current_tree, :other_tree, :stage, :checksum) do
  def before
    Flexite::JobReport.new.tap do |report|
      report.stage    = stage
      report.checksum = checksum
      report.status   = Flexite::JobReport::STATUS[:in_progress]
    end.save
  end

  def perform
    Flexite::Diff::CheckService.new(current_tree, other_tree, stage, checksum).call
  end

  def success
    Flexite::JobReport
      .where(stage: stage, checksum: checksum)
      .first
      .update_attributes(status: Flexite::JobReport::STATUS[:done])
  end

  def error
    Flexite::JobReport
      .where(stage: stage, checksum: checksum)
      .first
      .update_attributes(status: Flexite::JobReport::STATUS[:error])
  end
end
