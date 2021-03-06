module Flexite
  class Diff
    class SyncShowService
      def initialize(stage, url)
        @stage = stage
        @remote_diff = Diff.new(url)
        @state_digest = Flexite.state_digest
      end

      def call
        response = Flexite.cache.read("#{@state_digest}-#{@stage}-show-diff")

        if response.nil?
          expire_old
          nodes = Config.t_nodes
          checksum = Digest::MD5.hexdigest(nodes.to_json)
          Flexite.cache.write("#{@state_digest}-#{@stage}-diff-checksum", checksum)
          response = @remote_diff.check({ token: Flexite.config.migration_token, tree: nodes, stage: Flexite.config.stagename, checksum: checksum })
          Flexite.cache.write("#{@state_digest}-#{@stage}-show-diff", response)
        end

        result(response)
      end

      protected

      def expire_old
        Flexite.cache.delete_matched(Flexite.match_key("-#{@stage}-show-diff"))
        Flexite.cache.delete_matched(Flexite.match_key("-#{@stage}-diff-checksum"))
      end

      def result(response)
        if response[:error].present?
          expire_old
          ActionService::Result.new(success: false, flash: { type: :danger, message: response[:error] }, endpoint: { partial: 'flexite/shared/show_flash' })
        else
          ActionService::Result.new(data: response[:diffs], endpoint: { action: :sync_show })
        end
      end
    end
  end
end
