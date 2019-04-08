module Flexite
  module Data
    class MigrateService

      def self.call
        new.call
      end

      def call
        pending_migrations.each do |version|
          with_logger(version) do
            ActiveRecord::Base.transaction do
              migrate(version)
              SettingsMigration.create!(version: version)
            end
          end
        end
      end

      private

      def pending_migrations
        migrations = Dir['./config/settings/migrate/*.yml'].map do |filename|
          File.basename(filename, '.yml')
        end
        run_migrations = Flexite::SettingsMigration.pluck(:version)
        migrations - run_migrations
      end

      def migrate(version)
        settings = YAML.load_file("./config/settings/migrate/#{version}.yml")
        settings.each do |root_key, value|
          parent, hash = parent_with_hash(root_key, value)
          Flexite::Data::AddService.new(parent, hash).call
        end
      end

      def parent_with_hash(root_key, settings)
        parent = Flexite::Config.roots.where(name: root_key).first
        hash   = settings
        return [root_key, hash] if parent.blank?

        settings.each do |key, value|
          config = Flexite::Config.where(name: key, config_id: parent.id).first
          if config.present?
            parent = config
            hash   = value
          end
        end
        [parent, hash]
      end

      def with_logger(version)
        puts "Run settings migration VERSION=#{version}"
        yield if block_given?
        puts "Settings migration VERSION=#{version} was applied"
      end
    end
  end
end
