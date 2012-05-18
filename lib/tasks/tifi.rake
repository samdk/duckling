namespace :tifi do
  task :start => :environment do
    Rails.application.eager_load!
  
    t = Tifi.new(debug: Rails.env.development?)
    
    t.tasks << TifiTasks::Invitations.new << TifiTasks::Notifications.new
    
    t.run(daemonize: ENV.key?('background'))
  end
end