class SessionsController < ApplicationController
  TEMP_PLACEHOLDER_OTP = 420042

  layout 'login'

  def new
    @session_form = SessionForm.new
  end

  def create
    @session_form = SessionForm.new(phone: params[:session][:phone])
    respond_to do |format|
      if @session_form.valid?
        Twilio::PhoneVerification.start(@session_form.user.phone)
        format.html { redirect_to action: :verify, user_id: @session_form.user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  def verify
    @user = User.find(params[:user_id])
  end

  def check_otp
    @user = User.find(params[:user_id])

    respond_to do |format|
      if is_otp_correct?
        @user.phone_successfully_verified! unless @user.phone_verified?
        log_in @user
        format.html { redirect_to root_path }
      else
        @error_message = 'We couldn’t match that one. Want to try again?'
        format.html { render :verify, status: :unprocessable_entity }
        format.js { render :check, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:phone)
  end

  DEV_ENVIRONMENT_OTP = '420042'

  def is_otp_correct?
    if Rails.env.development?
      params[:otp] == DEV_ENVIRONMENT_OTP
    else
      resp = Twilio::PhoneVerification.check(params[:otp], @user.phone)
      resp.code == 200
    end
  end
end
