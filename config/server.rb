config['channel'] = EM::Channel.new

world = World.new

EM.add_periodic_timer(0.1) do
  world.tick
  data = world.data_points

  config['channel'] << data.to_json
end
