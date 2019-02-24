class SubscribersController < ApplicationController
  def create
    @subscriber = Subscriber.new(subscriber_params)

    respond_to do |format|
      if @subscriber.save
        SubscriberMailer.email_verification(@subscriber).deliver_now
        format.js { render :create }
      else
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  def verification
    subscriber = Subscriber.find_by(email: params[:email])

    if subscriber && !subscriber.email_verified? && subscriber.verification_token_valid?(params[:subscriber_id])
      subscriber.email_successfully_verified!
      flash[:success] = "Your email was verified successfully!"
      redirect_to root_path
    else
      flash[:danger] = "Invalid verification link"
      redirect_to root_path
    end
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
