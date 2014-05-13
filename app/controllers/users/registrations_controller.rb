class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters
  before_filter :check_permissions, :only => [:new, :create]

  skip_before_filter :require_no_authentication
 
  def check_permissions
    authorize! :create, resource
  end

  def create
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :roles => [])
    devise_parameter_sanitizer.for(:account_update).push(:name, :roles => [])
  end

  def sign_up(resource_name, resource)
    true
  end

  def after_sign_up_path_for(resource)
    '/'
  end

end
