class Api::V1::UsersController < ApplicationController
  protect_from_forgery with: :null_session
  
  def login_api
    
    validate = validate_param_to_login
    if validate != ""
      data = {}
      message = validate
      status = 'error'
    else
      user = User.new
      begin
        data = Hash.new
        user_api = user.login_api params[:email], params[:pass]
        data['user'] = user_api[:user]
        data['token'] = user_api[:token]
        message = "Logged successfully"
        status = "success"
      rescue Exception => e
        data = {}
        message = "#{e.message}"
        status = "error"
      end
    end
    
    _response(status, data, message)
    
  end
  
  private
    def validate_param_to_login
      return "Please inform the param email" if !params.has_key?(:email)
      return "Please inform the param pass" if !params.has_key?(:pass)
      return  ""
    end
  
end
