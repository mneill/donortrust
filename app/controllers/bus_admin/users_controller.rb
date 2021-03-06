class BusAdmin::UsersController < ApplicationController
  layout 'admin'
  before_filter :login_required, :check_authorization
  #access_control :DEFAULT => 'cf_admin' 
  include BusAdmin::UsersHelper
  include UploadSyncHelper
  after_filter :sync_uploads, :only => [:create, :update, :destroy]
   
  active_scaffold do |config|
    
  #  config.label = "Donors"
  #  config.columns = [:country, :administrated_projects]
  #  config.columns[:administrated_projects].form_ui = :select
  #  config.columns[:projects].form_ui = :select
  #  config.actions.exclude :create
    config.columns = [ :first_name, :last_name, :login, :country, :roles, :staff, :title, :twitter, :facebook, :bio]
    config.columns[:roles].form_ui = :select 
    config.list.columns = [:first_name, :last_name, :login, :roles, :staff]
    config.update.columns = [:first_name, :last_name, :login, :display_name, :address,  :city, :province, :country, :postal_code, :administrations, :staff, :title, :twitter, :facebook, :bio]
    config.columns[:administrations].label = "Roles"    
  end
 
end
