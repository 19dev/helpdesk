module Helpdesk
  class Engine < ::Rails::Engine
    isolate_namespace Helpdesk

    config.i18n.default_locale = "en-EN"
    config.i18n.load_path += Dir[config.root.join('locales', '*.{yml}').to_s]
  end
end
