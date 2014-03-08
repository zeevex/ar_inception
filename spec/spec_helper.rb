
$: << File.expand_path(File.dirname(__FILE__) + '../lib')

require 'rspec'
require 'ar_inception'
require 'logger'

require 'active_support'
require 'active_record'

# sqlite doesn't support multiple active connections to the same DB
ENV['DB'] ||= (RUBY_ENGINE == 'jruby' ? 'jdbcmysql' : 'mysql')

database_yml = File.expand_path('../database.yml', __FILE__)
if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)[ENV['DB']]

  ActiveRecord::Base.establish_connection(active_record_configuration)
  ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))

  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false

    load(File.dirname(__FILE__) + '/schema.rb')
    load(File.dirname(__FILE__) + '/models.rb')
  end

else
  raise "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample"
end

