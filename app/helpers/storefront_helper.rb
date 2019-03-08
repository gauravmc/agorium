module StorefrontHelper
  private

  def set_brand
    @brand = Brand.find_by!(handle: params[:handle])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Brand named '#{params[:handle]}' does not exist."
    redirect_to root_path
  end
end
