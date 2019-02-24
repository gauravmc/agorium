# Preview all emails at http://localhost:3000/rails/mailers/subscriber_mailer
class SubscriberMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscriber_mailer/email_verification
  def email_verification
    subscriber = Subscriber.first
    subscriber.verification_token = Subscriber.new_token
    SubscriberMailer.email_verification(subscriber)
  end
end
