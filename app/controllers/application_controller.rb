class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to rails_admin.dashboard_path, :alert => exception.message
  end
  
  def _response(status, data, message)
    respond_to do |format|
      msg = { :status => status, :data => data, :message => message }
      format.json  { render :json => msg }
    end
  end
  
end
