[![Circle
CI](https://circleci.com/gh/gylaz/wormbots.svg?style=svg)](https://circleci.com/gh/gylaz/wormbots)

# Description
This is an worm farm simulation that uses Goliath to stream data via server-sent
events and JavaScript to render it on the front-end.

# Running
To run the app:

    ruby server.rb
It will be accessible on port 9000

# Gotchas
The data (string) in ```stream_send``` method must end with two '\n' characters.
