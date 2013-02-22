#!/usr/bin/env ruby
$:.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'goliath'
require 'goliath/websocket'
require 'tilt'
require 'json'
require 'haml'
require 'wormbots'

class Server < Goliath::WebSocket
  # render templated files from ./views
  include Goliath::Rack::Templates

  # render static files from ./public
  use Rack::Static,
    :root => Goliath::Application.app_path('public'),
    :urls => ['/stylesheets', '/javascripts', '/images']

  def on_open(env)
    env.logger.info('Connection open')
    env['subscription'] = env.channel.subscribe { |m| env.stream_send(m) }
  end

  def on_message(env, message)
    env.logger.info("Message: #{message}")
    env.channel << message
  end

  def on_close(env)
    env.logger.info('Connection closed')
    env.channel.unsubscribe(env['subscription'])
  end

  def on_error(env, error)
    env.logger.error error
  end

  def response(env)
    case env['REQUEST_PATH']
    when '/'
      [200, {}, haml(:index)]
    when '/world'
      super(env)
    end
  end
end
