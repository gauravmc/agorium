ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  WebMock.enable!

  def is_logged_in?
    !session[:user_id].nil?
  end

  def is_logged_in_as?(user)
    assert_equal user.id, session[:user_id]
  end

  def log_in_as(user)
    stub_request(:get, /api.authy.com/).to_return(status: 200)
    post check_otp_url(user.id), params: { otp: '420042' }
    assert is_logged_in_as?(user)
  end
end

module RemoveUploadedFiles
  def after_teardown
    super
    remove_uploaded_files
  end

  private

  def remove_uploaded_files
    FileUtils.rm_rf(Rails.root.join('tmp', 'storage'))
  end
end

module ActionDispatch
  class IntegrationTest
    prepend RemoveUploadedFiles
  end
end
