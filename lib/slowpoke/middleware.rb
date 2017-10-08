module Slowpoke
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    ensure
      #puts "in ensure"
      #puts "envkey: "
      #puts env[Slowpoke::ENV_KEY]
      if env[Slowpoke::ENV_KEY]
        # extremely important
        # protect the process with a restart
        # https://github.com/heroku/rack-timeout/issues/39
        # can't do in timed_out state consistently
        if defined?(::PhusionPassenger)
          puts "in phusionpassenger"
          `passenger-config detach-process #{Process.pid}`
        else
          Process.kill("QUIT", Process.pid)
        end
      end
    end
  end
end
