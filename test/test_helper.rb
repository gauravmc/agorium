ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  WebMock.enable!

  PRODUCT_FIXTURES_PHOTOS = {
    wedding_card: ['wedding_card.jpeg', 'wedding_card_2.jpeg'],
    summer_butter: ['summer_butter.jpeg', 'summer_butter_2.jpeg', 'summer_butter_3.jpeg'],
    fire_balm: ['fire_balm_1.jpeg'],
    charcoal_soap: ['charcoal_soap.jpeg', 'charcoal_soap_2.jpeg']
  }

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

  def attach_product_fixtures_photos
    PRODUCT_FIXTURES_PHOTOS.each do |fixture, filenames|
      p = products(fixture)
      filenames.each do |filename|
        p.photos.attach(io: file_fixture(filename).open, filename: filename)
      end
    end
  end

  def purge_product_fixtures_photos
    PRODUCT_FIXTURES_PHOTOS.keys.each do |fixture|
      products(fixture).photos.purge
    end
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
