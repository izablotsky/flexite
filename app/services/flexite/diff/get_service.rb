module Flexite
  class Diff
    class GetService
      include Flexite::Engine.routes.url_helpers

      def initialize(stage, endpoint)
        @stage = stage
        @endpoint = endpoint + api_configs_path(token: Flexite.config.migration_token)
        get_configs
      end

      def call
        return if Diff.exists?(stage: @stage, version: version)

        calculate_diff
      end

      private

      def get_configs
        uri = URI(@endpoint)
        response = Net::HTTP.get(uri)
        @other_tree = JSON.parse(response)
        @current_tree = Config.t_nodes
      end

      def calculate_diff
        Delayed::Job.enqueue(ShowDiffJob.new(@other_tree, @current_tree, @stage, version))
      end

      def version
        @version = DateTime.now.strftime('%Y%m%d')
      end

      def no_difference?
        @other_checksum == @current_checksum
      end
    end
  end
end
