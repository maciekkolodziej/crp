class RegistrationsController < Devise::RegistrationsController
  def confirmation
  end
  
  protected

  def after_inactive_sign_up_path_for(resource)
    '/registrations/confirmation'
  end
end