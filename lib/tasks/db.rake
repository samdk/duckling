namespace :db do
  task :redo    => %w[db:drop db:create db:migrate db:seed]
  task :redo_ns => %w[db:drop db:create db:migrate]
end

task :clear_cache => :environment do
  Rails.cache.clear
end