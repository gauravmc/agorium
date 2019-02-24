class SubscriberMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscriber_mailer.email_verification.subject
  #
  def email_verification(subscriber)
    @subscriber = subscriber
    mail to: subscriber.email, subject: "Email ownership verification"
  end
end
