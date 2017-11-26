# central_auth
A centralized authentication service writen in Ruby using the Rack web API.

# Todo
1. Parameterize the sql query in lib/auth.rb. I haven't tested it for injection yet but i'll buy you a beer if it isn't vulnerable.
2. Nginx auth is incomplete. I need to locate a reference implementation of an Nginx auth service and flesh it out.
3. The input validation in lib/validate.rb isn't quite finished yet so all code relating to validation in config.ru is commented out.
