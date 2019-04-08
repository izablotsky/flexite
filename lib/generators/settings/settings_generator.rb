class SettingsGenerator < Rails::Generators::Base
  def create_settings_file
    create_file("config/settings/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}.yml")
  end
end
