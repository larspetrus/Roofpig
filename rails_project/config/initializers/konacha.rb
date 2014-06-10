Konacha.configure do |config|
  config.spec_dir     = "test/coffeescripts"
  config.spec_matcher = /_spec\.|_test\./
  config.stylesheets  = %w(application)
  config.driver       = :selenium
end if defined?(Konacha)
