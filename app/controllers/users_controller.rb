class UsersController < ApplicationController
  TEMP_PLACEHOLDER_OTP = 420042

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_verify_path(@user) }
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
        @user.phone_successfully_verified!
        format.html { redirect_to root_path }
      else
        @user.errors.add(:base, 'OTP did not match, please try entering again.')
        format.html { render :verify }
        format.js { render :check_otp, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone)
  end
end
