require "test_helper"

class ApplicationConfigurationTest < ActiveSupport::TestCase
  test "stores sessions in the encrypted cookie shared by all Puma workers" do
    assert_equal ActionDispatch::Session::CookieStore, Rails.application.config.session_store
    assert_equal 10.minutes, Rails.application.config.session_options[:expire_after]
  end
end
