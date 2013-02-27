config['channel'] = EM::Channel.new

world = World.new

EM.add_periodic_timer(0.1) do
  world.tick
  points = world.data_points

  config['channel'] << points
end
