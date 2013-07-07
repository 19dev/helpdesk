module Helpdesk
  class ApplicationController < ::ApplicationController
  	layout "layouts/application"

  	def current_engine
  		"helpdesk"
  	end
  end
end
