module Helpdesk
  class Engine < ::Rails::Engine
    isolate_namespace Helpdesk

    config.i18n.default_locale = "en-EN"
    config.i18n.load_path += Dir[config.root.join('locales', '*.{yml}').to_s]

    initializer "helpdesk.action_controller" do |app|
    	ActiveSupport.on_load :action_controller do
    		helper Helpdesk::TicketsHelper
    	end
    end
  end
end
