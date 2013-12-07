class SessionController < ApplicationController   
  
  # GET /per_page
  def per_page
    params[:records_per_page] = session[:records_per_page]
  
    respond_to do |format|
      format.js { render('shared/build_modal') }
    end
  end
  
  # POST /update_per_page
  def update_per_page
    session[:records_per_page] = params[:records_per_page]
    respond_to do |format|
      format.js { render js: "close_modal(); redirect('#{request.referer}')"}
    end
  end
end