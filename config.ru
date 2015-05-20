require 'dashing'
if Sinatra::Base.development?
  require 'dotenv'
  Dotenv.load
end  

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