require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :spec do
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
