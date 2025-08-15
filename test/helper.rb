require 'minitest/autorun'
require 'minitest/spec'
require 'minitest-spec-context'
require 'vcr'
require 'webmock'

require_relative '../lib/poloniex'

VCR.configure do |config|
  config.cassette_library_dir = File.join(__dir__, 'fixtures', 'vcr_cassettes')
  config.hook_into :webmock

  config.filter_sensitive_data('<API_KEY>'){ENV['POLONIEX_API_KEY']}
  config.filter_sensitive_data('<API_SECRET>'){ENV['POLONIEX_API_SECRET'] }

  config.ignore_localhost = true # Allow localhost connections for debugging.
  # config.debug_logger = $stderr # Uncomment for debug output from VCR.

  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: [:method, :path, :body]
  }
end

class Minitest::Test
  def before_setup
    super
    Poloniex.reset_configuration!
  end
end
