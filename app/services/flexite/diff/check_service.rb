module Flexite
  class Diff
    class CheckService
      def initialize(current_tree, other_tree, stage, checksum)
        @other_tree = other_tree
        @current_tree = current_tree
        @stage = stage
        @checksum = checksum
      end

      def call
        HashDiff.diff(@other_tree, @current_tree, array_path: true, use_lcs: false).each do |type, depth, *changes|
          Diff.new.tap do |diff|
            diff.stage        = @stage
            diff.checksum     = @checksum
            diff.change_type  = type
            diff.path         = depth
            diff.hash_changes = changes
          end.save
        end
      end
    end
  end
end
