class ApplicationController < ActionController::Base
  # Authenticate user for all actions
  before_filter :authenticate_user!
  
  # Workaround to: CanCan causing ForbiddenAttributesError
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  
  # For userstamp gem
  include Userstamp
  
  load_and_authorize_resource unless: [:devise_controller?, :skip_controller?]
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  # Inflection method for genders
  inflection_method :gender
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Access denied page
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to request.referer ? request.referer : root_path, alert: exception.message
  end
  
  def records_per_page
    session[:records_per_page] ||=  Wice::Defaults::PER_PAGE
  end
  
  # Include locale in every url
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    options.merge({ :locale => I18n.locale })
  end
  
  # Set locale before every action
  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def gender
    @gender || nil
  end
  
  def skip_controller?
    controllers_to_skip = ['dashboard', 'session', 'demo', 'histories']
    controllers_to_skip.include?(params[:controller]) ? true : false
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name
    devise_parameter_sanitizer.for(:account_update) << :first_name << :last_name
  end
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    user_session_path
  end
  
  def after_sign_in_path_for(user)
      session['user_return_to'] || locale_root_path
  end
  
end