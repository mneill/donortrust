class BusAdmin::QuickFactPlacesController < ApplicationController
  before_filter :login_required#, :check_authorization
  
  active_scaffold :quick_fact_places do |config|
    config.label = "Quick Facts"
    config.columns = [ :quick_fact,:description, :place ]    
    config.columns[ :quick_fact ].form_ui = :select
    config.columns[ :place ].form_ui = :select    
    update.columns.exclude [:place]    
 #   config.action_links.add 'index', :label => '<img src="/images/icons/you_tube.png" border=0>', :page => true, :type=> :record, :parameters =>{:controller=>"bus_admin/quick_fact_place_you_tube_videos"}
    config.action_links.add 'index', :label => '<img src="/images/icons/you_tube.png" border=0>', :page => true, :type=> :record, :parameters =>{:controller=>"bus_admin/project_you_tube_videos"}
  end
end