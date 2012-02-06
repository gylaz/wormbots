require 'goliath'
require 'tilt'

class World < Goliath::API
	# render templated files from ./views
	#include Goliath::Rack::Templates
	# use Rack::Static,
	# 	:urls => ["/index.html"],
	# 	:root => Goliath::Application.app_path("public")

	# render static files from ./public
	#use(Rack::Static,
	#	:root => Goliath::Application.app_path("public"),
  # :urls => ["/favicon.ico", '/stylesheets', '/javascripts', '/images'])

  def response(env)
    EM.add_periodic_timer(1) do
    	# must have two \n at the end
    	env.stream_send("data: #{rand(100)}\n\n")
		end

		streaming_response(200, {'Content-Type' => 'text/event-stream'})
  end
end


class SSE < Goliath::API
	use Rack::Static,
		:urls => ["/index.html"],
		:root => Goliath::Application.app_path("public")
	get "/events" do
		run World.new
	end	
end