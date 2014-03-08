unless RUBY_VERSION.match(/^2\./)
  appraise "rails-2" do
    gem "activerecord", "2.3.18"
    gem "activesupport", "2.3.18"
  end
end

appraise "rails-3" do
  gem "activerecord", "3.2.14"
  gem "activesupport", "3.2.14"
end

# AR 4 doesn't support Ruby 1.8.7
unless RUBY_VERSION.match(/^1\.8\./)
  appraise "rails-4" do
    gem "activerecord", "4.0.0"
    gem "activesupport", "4.0.0"
  end
end
