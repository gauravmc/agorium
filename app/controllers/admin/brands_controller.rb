class Admin::BrandsController < AdminController
  skip_before_action :ensure_account_setup_completed, only: [:new, :create]
  before_action :check_if_brand_exists, only: [:new, :create]
  before_action :set_brand, only: [:edit, :update]

  def new
    @brand = current_user.build_brand
    render layout: 'plain_admin'
  end

  def create
    @brand = current_user.build_brand(brand_params)

    respond_to do |format|
      if @brand.save
        flash[:success] = "Your account is fully set up now. Welcome! You can start by adding some products."
        format.html { redirect_to admin_root_path }
      else
        flash.now[:danger] = "Could not finish setting up your account. Please check errors below."
        format.html { render :new, status: :unprocessable_entity, layout: 'plain_admin' }
        format.js { render :create, status: :unprocessable_entity, layout: 'plain_admin' }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @brand.update(brand_params)
        flash[:success] = "Your brand settings were successfully updated."
        format.html { redirect_to edit_admin_brand_path }
      else
        flash.now[:danger] = "Could not update your brand settings. Please check errors below."
        format.html { render :edit, status: :unprocessable_entity }
        format.js { render :update, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_brand
    @brand = current_brand
  end

  def brand_params
    params.require(:brand).permit(:name, :tagline, :story, :city, :state)
  end

  def check_if_brand_exists
    redirect_to admin_root_path if current_user.brand.present?
  end
end
