set :cron_log, "#{Rails.root}/log/corevist_cron.log"
set :environment, Rails.env

case @environment
when 'qa'
  every 1.day, at: '00:00pm' do
    rake 'flexite:check_diff'
  end
when 'production'
  every 1.day, at: '00:00pm' do
    rake 'flexite:check_diff'
  end
end
