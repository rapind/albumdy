# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include AuthenticatedSystem

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4dedc3c0ed5c809a5a6ef57727f366c9'
  
  # this removes the layout for all ajax requests across the board
  layout proc { |controller| controller.request.xhr? ? nil : 'application' }

  before_filter :set_meta
  
  def sub_nav
    'default'
  end
  
  def set_meta
    @page_title = 'Who is Albumdy?'
    @page_description = 'Albumdy is an open source photo gallery built using Ruby on Rails, jQuery, and some of my other favorite technologies, plugins, and practices.'
    @page_keywords = 'album, photo, gallery, ruby, rails, ruby on rails, open source, blueprint, jquery, lightbox, thickbox, resource_controller, attachment_fu, restful_authentication, braid, github'
  end
  
end
