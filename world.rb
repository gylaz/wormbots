require 'goliath'
require 'tilt'

class World < Goliath::API
  def response(env)
    EM.add_periodic_timer(1) do
    	# must have two \n at the end
    	env.stream_send("data: #{rand(100)}\n\n")
		end

		streaming_response(200, {'Content-Type' => 'text/event-stream'})
  end
end

class Routes < Goliath::API
	# render templated files from ./views
	include Goliath::Rack::Templates
	
	# render static files from ./public
	use(Rack::Static,
		:root => Goliath::Application.app_path('public'),
		:urls => ['/stylesheets', '/javascripts'])
		# :urls => ['/favicon.ico', '/stylesheets', '/javascripts', '/images'])

	get '/world', World
	
	def response(env)
		[200, {}, haml(:index)]
	end
end