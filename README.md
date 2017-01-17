[![Codacy Badge](https://api.codacy.com/project/badge/Grade/41fbc9cc25a649a2afb4d644edecb632)](https://www.codacy.com/app/gylaz/wormbots?utm_source=github.com&utm_medium=referral&utm_content=gylaz/wormbots&utm_campaign=badger)
[![Circle CI](https://circleci.com/gh/gylaz/wormbots.svg?style=svg&circle-token=54ffe27f997f0c5c37abbc68ed2e8b13c25dcafd)](https://circleci.com/gh/gylaz/wormbots)

# Description
This is an worm farm simulation that uses Goliath to stream data via server-sent
events and JavaScript to render it on the front-end.

# Running
To run the app:

    ruby server.rb
It will be accessible on port 9000

# Gotchas
The data (string) in ```stream_send``` method must end with two '\n' characters.
