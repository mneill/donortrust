
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include BusAdmin::UserInfo
  
  before_filter :set_user
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_donortrust_session_id'
   #before_filter :login_from_cookie
  def login_required
    unless session[:user]
    flash[:notice] = "Please log in" 
    session[:jumpto] = request.parameters
    redirect_to(:controller => "/bus_admin/bus_account", :action => "login")
    end 
  end
  
  protected
  def set_user
    BusAdmin::UserInfo.current_user = session[:user]
  end
  
end
