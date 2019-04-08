desc 'task to migrate new settings to current environment'
namespace :settings do
  task migrate: :environment do
    Flexite::Data::MigrateService.call
  end
end
