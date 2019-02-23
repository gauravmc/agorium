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
        # TODO: Trigger real OTP message
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
      if params[:otp] == TEMP_PLACEHOLDER_OTP.to_s # TODO: Add real OTP check
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
    log_out
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:phone)
  end
end
