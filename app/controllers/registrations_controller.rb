class RegistrationsController < Devise::RegistrationsController
  def gender
    'male'
  end
  
  def confirmation
  end
  
  def edit
    respond_to do |format|
      format.html { }
      format.js { render('shared/build_user_modal') }
    end
  end
  
  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    
    respond_to do |format|
      if update_resource(resource, account_update_params)
        yield resource if block_given?
        sign_in resource_name, resource, :bypass => true
        success = t("messages.saved.#{self.gender}", default: [:'messages.saved', 'User was sucessfully saved.'], model: User.model_name.human)
        format.html { redirect_to after_update_path_for(resource), notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
        #respond_with resource, :location => after_update_path_for(resource)
      else
        clean_up_passwords resource
        format.html { render action: "edit" }
        format.js { render('shared/user_form_with_errors') }
      end
    end
  end
  
  protected

  def after_inactive_sign_up_path_for(resource)
    '/registrations/confirmation'
  end

end