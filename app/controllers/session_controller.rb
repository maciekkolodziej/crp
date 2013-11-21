class SessionController < ApplicationController   
  # POST /records_per_page
  def records_per_page
    session[:records_per_page] = params[:records_per_page]
    redirect_to request.referer
  end
end