config['channel'] = EM::Channel.new

world = World.new
config['start_time'] = world.start_time

EM.add_periodic_timer(0.1) do
  world.tick
  config['channel'] << world.data_points
end
