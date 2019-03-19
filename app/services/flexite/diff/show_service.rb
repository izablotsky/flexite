module Flexite
  class Diff
    class ShowService
      def initialize(stage)
        @stage   = stage
        @version = DateTime.now.strftime('%Y%m%d')
        @data    = {diffs: {}}
      end

      def call
        if (diffs = Diff.where(stage: @stage, version: @version)).present?
          @data[:diffs] = diffs.group_by(&:change_type)
        end

        Flexite::ActionService::Result.new(data: @data)
      end
    end
  end
end
