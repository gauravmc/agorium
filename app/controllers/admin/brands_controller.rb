class Admin::BrandsController < AdminController
  layout 'plain_admin'

  skip_before_action :ensure_account_setup_completed
  before_action :check_if_brand_exists

  def new
    @brand = current_user.build_brand
  end

  def create
    @brand = current_user.build_brand(brand_params)

    respond_to do |format|
      if @brand.save
        flash[:success] = "Your account is fully set up now. Welcome! You can start by adding some products."
        format.html { redirect_to admin_root_path }
      else
        flash.now[:danger] = "Could not finish setting up your account. Please check errors below."
        format.html { render :new, status: :unprocessable_entity }
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  private

  def brand_params
    params.require(:brand).permit(:name, :story, :city, :state)
  end

  def check_if_brand_exists
    redirect_to admin_root_path if current_user.brand.present?
  end
end
