class SessionsController < ApplicationController
  layout 'login'

  def new
    @session_form = SessionForm.new
  end

  def create
    @session_form = SessionForm.new(phone: params[:session][:phone])
    respond_to do |format|
      if @session_form.valid?
        # Redirect to OTP entering
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  private

  def session_params
    params.require(:session).permit(:phone)
  end
end
