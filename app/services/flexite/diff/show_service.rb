module Flexite
  class Diff
    class ShowService
      def initialize(stage, checksum)
        @stage = stage
        @checksum = checksum
      end

      def call
        @data = { stage: @stage, checksum: @checksum }
        if (diffs = Diff.where(stage: @stage, checksum: @checksum)).present?
          @data[:diffs] = diffs.group_by(&:change_type)
        end

        Flexite::ActionService::Result.new(data: @data)
      end
    end
  end
end
