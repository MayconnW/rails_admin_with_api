RailsAdmin.config do |config|
  
  config.excluded_models = ["UserApi"]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
  
  config.authorize_with :cancan
  
  config.authenticate_with do
    warden.authenticate! scope: :user
    if (current_user.role.name != 'admin') && (current_user.role.name != 'user')
      redirect_to main_app.signout_path
    end
  end
  
  config.current_user_method(&:current_user)
  
  config.main_app_name = ["Application", "Administration"]
  
  config.parent_controller = 'ApplicationController'
  
end
