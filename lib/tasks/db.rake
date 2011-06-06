namespace :db do
  task :redo => ['db:drop', 'db:create', 'db:migrate', 'db:seed']
end

task :clear_cache => :environment do
  Rails.cache.clear
end