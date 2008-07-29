# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4dedc3c0ed5c809a5a6ef57727f366c9'
  
  # this removes the layout for all ajax requests across the board
  layout proc { |controller| controller.request.xhr? ? nil : 'application' }
  
end
