module Twilio
  class PhoneVerification
    API_URI = "https://api.authy.com/protected/json/phones/verification".freeze
    COUNTRY_CODE = 91
    HEADERS = {
      'X-Authy-API-Key' => Rails.application.credentials[Rails.env.to_sym][:twilio_verify_key]
    }
    OTP_LENGTH = 6

    class << self
      def start(phone)
        return if Rails.env.development?

        twilio_params = {
          phone_number: phone,
          via: 'sms',
          country_code: COUNTRY_CODE,
          code_length: OTP_LENGTH,
          locale: 'en'
        }

        HTTP.headers(HEADERS).post("#{API_URI}/start", params: twilio_params)
      end

      def check(otp, phone)
        return if Rails.env.development?

        twilio_params = {
          phone_number: phone,
          country_code: COUNTRY_CODE,
          verification_code: otp
        }

        HTTP.headers(HEADERS).get("#{API_URI}/check", params: twilio_params)
      end
    end
  end
end
