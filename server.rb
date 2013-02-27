#!/usr/bin/env ruby
$:.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'goliath'
require 'json'
require 'haml'
require 'wormbots'

class Server < Goliath::API
  # render templated files from ./views
  include Goliath::Rack::Templates

  # render static files from ./public
  use Rack::Static,
    :root => Goliath::Application.app_path('public'),
    :urls => ['/stylesheets', '/javascripts', '/images']

  def on_close(env)
    if env['subscription']
      env.logger.info('Connection closed')
      env.channel.unsubscribe(env['subscription'])
    end
  end

  def on_error(env, error)
    env.logger.error(error)
  end

  def response(env)
    case env['REQUEST_PATH']
    when '/'
      [200, {}, haml(:index)]
    when '/world'
      env['subscription'] = env.channel.subscribe do |message|
        env.stream_send("data: #{message.to_json}\n\n")
      end

      streaming_response(200, {'Content-Type' => 'text/event-stream'})
    end
  end
end
