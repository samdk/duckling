namespace :tifi do
  task :start => :environment do
    Rails.application.eager_load!
  
    Tifi.new(debug: Rails.env.development?).run(daemonize: ENV.key?('background'))
  end
end