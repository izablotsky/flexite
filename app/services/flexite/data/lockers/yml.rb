module Flexite
  module Data
    module Lockers
      class Yml

        def initialize
          @env_configs = Flexite.config.env_configs
        end

        def call
          @env_configs.each do |path|
            next unless File.exist?(path)

            find_and_lock(YAML.load_file(path), Flexite::Config)
          end
        end

        private

          def find_and_lock(hash, config)
            hash.each do |key, value|
              config_to_lock = if config.respond_to?(:find_by_name)
                                config.find_by_name(key)
                               else
                                config.configs.find_by_name(key)
                               end
              if value.is_a?(Hash)
                find_and_lock(value, config_to_lock)
              else
                lock(config_to_lock)
              end
            end
          end

          def lock(config)
            config.locked = true
            config.save
          end
      end
    end
  end
end
