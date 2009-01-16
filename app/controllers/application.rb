# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  layout 'standard'

  if ENV['RAILS_ENV'] != 'test'
    requires_authentication :using => lambda{ |username, password| username == 'bbteam' && password == 'gang0ftw0' }, :realm => 'BB Admin Panel'
  end
end
