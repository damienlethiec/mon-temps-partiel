class ApplicationController < ActionController::Base
  before_action :masquerade_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_payer
    # 'Current' method to refer to for Stripe methods (eg. `.subscription`, etc)
    # Defaults to `current_company`. This is also the class
    # where `include Sjabloon::Stripe` is included (eg. Company)
    current_company
  end
  helper_method :current_payer


  def current_company
    current_user.companies.friendly.find(params[:company_id] || current_user.company_id)
  end
  helper_method :current_company
  
  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
