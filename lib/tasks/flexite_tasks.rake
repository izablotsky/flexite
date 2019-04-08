desc 'Base engine tasks'
namespace :flexite do
  task convert_yml: :environment do
    puts 'Converting....'
    result = Flexite::Data::NewService.new(Flexite::Data::Migrators::Yaml.new).call
    puts 'Finished'
    puts 'Errors:'

    result[:errors].each do |object, errors|
      puts "record: #{object.inspect}"

      errors.each do |error|
        puts "message: #{error.first}"
        puts "backtrace: #{error.last}"
      end

      puts '-' * 70
    end
  end

  task lock_settings: :environment do
    begin
      puts 'Locking...'
      Flexite::Data::Lockers::Yml.new.call
      puts 'Locked'
    rescue StandardError => exception
      puts 'Smth went wrong'
    end
  end

  task remove_settings: :environment do
    begin
      puts 'Removing....'
      Flexite::Config.transaction do
        Flexite::Config.delete_all
        Flexite::Entry.delete_all
        Flexite::History.delete_all
        Flexite::HistoryAttribute.delete_all
      end
      puts 'Deleted'
    rescue StandardError => exc
      puts 'Smth went wrong...'
    end
  end

  task check_diff: :environment do
    Flexite.config.stages.each do |(stage, endpoint)|
      Flexite::Diff::GetService.new(stage, endpoint).call
    end
  end
end
