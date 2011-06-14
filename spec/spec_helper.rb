require 'rubygems'
require 'spork'

Spork.prefork do

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'stringio'

  RSpec.configure do |config|

    config.mock_with :rspec
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    config.use_transactional_examples = true
    config.use_transactional_fixtures = true

    config.around(:each) do |example|
      strio = StringIO.new
      ActiveRecord::Base.logger = Logger.new(strio)
      ex = example.run
      if RSpec::Expectations::ExpectationNotMetError === ex
        ex.message << strio.string
      end
    end
  end
  
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
end


