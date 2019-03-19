module Flexite
  class Diff
    class CheckService
      def initialize(current_tree, other_tree, stage, version)
        @other_tree   = other_tree
        @current_tree = current_tree
        @stage        = stage
        @version      = version
      end

      def call
        HashDiff.diff(@other_tree, @current_tree, array_path: true).each do |type, depth, *changes|
          Diff.new.tap do |diff|
            diff.stage        = @stage
            diff.version      = @version
            diff.change_type  = type
            diff.path         = depth
            diff.hash_changes = changes
          end.save
        end
      end
    end
  end
end
