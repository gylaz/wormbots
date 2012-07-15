#!/usr/bin/env ruby
$:.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'goliath'
require 'tilt'
require 'json'
require 'haml'
require 'wormbots'

class Server < Goliath::API
  def response(env)
    fiber = $world.fiber
    EM.add_periodic_timer(0.1) do
      data = fiber.resume
    	# must have two \n at the end
    	env.stream_send("data: #{data.to_json}\n\n")
		end

		streaming_response(200, {'Content-Type' => 'text/event-stream'})
  end
end

class Routes < Goliath::API
	# render templated files from ./views
	include Goliath::Rack::Templates
	
	# render static files from ./public
	use(
    Rack::Static,
		:root => Goliath::Application.app_path('public'),
		:urls => ['/stylesheets', '/javascripts', '/images'])
		# :urls => ['/favicon.ico', '/stylesheets', '/javascripts', '/images'])

	get '/world', Server
	
	def response(env)
		[200, {}, haml(:index)]
	end
end

$world = World.new
