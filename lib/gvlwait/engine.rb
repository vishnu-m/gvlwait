module Gvlwait
  class Engine < ::Rails::Engine
    isolate_namespace Gvlwait

    initializer "gvlwait.add_middleware" do |app|
      app.middleware.use Gvlwait::GvlInstrumentationMiddleware
    end
  end
end
