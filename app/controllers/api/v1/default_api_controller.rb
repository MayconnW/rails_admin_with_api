class Api::V1::DefaultApiController < ApplicationController
  protect_from_forgery with: :null_session
  
  before_action :require_token
  #@user_api_logged is available in all controllers that come to this
 
  private
 
  def require_token
    validate = validate_param_api
    if validate != ""
      data = []
      message = validate
      status = 'error'
      return _response(status, data, message)
    end
    
    @user_api_logged = UserApi.find_by_token(params[:token])
    if !@user_api_logged
      data = []
      message = "Invalid token"
      status = 'error'
      return _response(status, data, message)
    end
  end
  
  private
    def validate_param_api
      return "Please inform the param token" if !params.has_key?(:token)
      return  ""
    end
  
end