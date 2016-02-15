def development_require(gem)
  require gem if ENV['RACK_ENV'] == 'development'
end

require 'dashing'
development_require 'dotenv'

Dotenv.load

set :protection, :except => :frame_options

configure do
  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
