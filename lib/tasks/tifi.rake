namespace :tifi do
  task :start => :environment do
    Rails.application.eager_load!
  
    t = Tifi.new(debug: Rails.env.development?)
    
    t.tasks << TifiTasks::Invitations.new
    t.tasks << TifiTasks::Notifications.new
    t.tasks << TifiTasks::Async.new
    
    t.run(daemonize: ENV.key?('background'))
  end
end