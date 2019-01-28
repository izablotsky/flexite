module Flexite
  class Diff
    class GetService
      include Flexite::Engine.routes.url_helpers

      def initialize(stage, endpoint)
        @stage = stage
        @endpoint = endpoint + api_configs_path(token: Flexite.config.migration_token)
        get_configs
        @checksum = checksum
      end

      def call
        if no_difference?
          ActionService::Result.new(flash: { type: :success, message: 'There is no difference btw envs' })
        elsif Diff.exists?(stage: @stage, checksum: @checksum)
          Diff::ShowService.new(@stage, @checksum).call
        else
          calculate_diff
          ActionService::Result.new(data: { stage: @stage, checksum: @checksum })
        end
      end

      private

      def get_configs
        uri = URI(@endpoint)
        response = Net::HTTP.get(uri)
        @other_tree = JSON.parse(response)
        @current_tree = Config.t_nodes
      end

      def calculate_diff
        # Delayed::Job.enqueue(ShowDiffJob.new(@other_tree, @current_tree, @stage, @checksum))
        CheckService.new(@current_tree, @other_tree, @stage, @checksum).call
      end

      def checksum
        @other_checksum = Digest::MD5.hexdigest(@other_tree.to_json)
        @current_checksum = Digest::MD5.hexdigest(@current_tree.to_json)
        Digest::MD5.hexdigest("#{@other_checksum}#{@current_checksum}")
      end

      def no_difference?
        @other_checksum == @current_checksum
      end
    end
  end
end
