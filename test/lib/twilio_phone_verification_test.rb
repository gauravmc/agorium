require 'test_helper'

class TwilioPhoneVerificationTest < ActiveSupport::TestCase
  test "start sends a post request with given phone number" do
    stub_request(:post, "https://api.authy.com/protected/json/phones/verification/start").
      with(
        query: {
          code_length: 6,
          country_code: 91,
          locale: 'en',
          phone_number: '9800098000',
          via: 'sms'
        }).
      with(
        headers: {
          'Connection' => 'close',
          'Host' => 'api.authy.com',
          'User-Agent' => 'http.rb/4.0.5',
          'X-Authy-Api-Key' => 'twilio_test_key'
        }).
      to_return(status: 200, body: "", headers: {})

    assert Twilio::PhoneVerification.start('9800098000')
  end

  test "check sends a get request with given phone number and otp" do
    stub_request(:get, "https://api.authy.com/protected/json/phones/verification/check").
      with(
        query: {
          country_code: 91,
          phone_number: '9800098000',
          verification_code: '420042'
        }).
      with(
        headers: {
          'Connection' => 'close',
          'Host' => 'api.authy.com',
          'User-Agent' => 'http.rb/4.0.5',
          'X-Authy-Api-Key' => 'twilio_test_key'
        }).
      to_return(status: 200, body: "", headers: {})

    assert Twilio::PhoneVerification.check('420042', '9800098000')
  end
end
