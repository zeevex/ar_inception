require 'rubygems'
require 'bundler/setup'
require 'appraisal'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  SPEC_PLATFORMS = ENV.has_key?('SPEC_PLATFORMS') ? 
        ENV['SPEC_PLATFORMS'].split(/ +/) :
        %w{1.8.7 2.0.0-p247 1.9.3-p448 jruby-1.7.9}

  def _run_commands_with_rbenv(version, commands)
      Bundler.with_clean_env do
        system %{bash -c 'eval "$(rbenv init -)" && unset GEM_HOME GEM_PATH && rbenv shell #{version} && } + 
           Array(commands).join(' && ') + "'"
      end
  end


  desc "Run on three Rubies"
  task :platforms do
    # current = %x[rbenv version | awk '{print $1}']
    
    fail = false
    SPEC_PLATFORMS.each do |version|
      puts "Switching to #{version}"
      _run_commands_with_rbenv(version, ["ruby -v", 
                                         "bundle exec rake appraisal spec"])
      if $?.exitstatus != 0
        fail = true
        break
      end
    end

    exit (fail ? 1 : 0)
  end

  desc 'Install gems for all tested rubies'
  task :platform_setup do
     SPEC_PLATFORMS.each do |version|
      puts "Setting up platform #{version}"
      _run_commands_with_rbenv(version, ["ruby -v", 
                                         "gem install bundler", 
                                         "bundle install",
                                         "bundle exec rake appraisal:install"])
    end   
  end
end

namespace :oldspec do
  desc "Run on three Rubies"
  task :platforms do
    current = %x{rvm-prompt v}

    fail = false
    %w{1.9.3 2.0.0 2.1.0}.each do |version|
      puts "Switching to #{version}"
      Bundler.with_clean_env do
        system %{zsh -i -c 'source ~/.rvm/scripts/rvm && rvm #{version} && gem install bundler && bundle install && bundle exec rake spec'}
      end
      if $?.exitstatus != 0
        fail = true
        break
      end
    end

    system %{rvm #{current}}

    exit (fail ? 1 : 0)
  end
end


task :repl do
  sh %q{ bundle exec irb -Ilib -r spec/spec_helper }
end

task :default => 'spec'
