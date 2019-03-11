module Flexite
  module Data
    class NewService
      include SaveMethods
      
      def initialize(migrator)
        @migrator = migrator
        @errors = ::Hash.new { |h, k| h[k] = [] }
        @result = {}
      end

      def call
        @migrator.call.each do |root, configs|
          begin
            @result[root] = save_root(root, configs)
          rescue => exc
            @errors[root] << [exc.message, exc.backtrace]
          end
        end

        @result.tap do |result|
          result[:errors] = @errors
        end
      end
    end
  end
end
