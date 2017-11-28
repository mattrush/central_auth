# central_auth
A centralized authentication service written in Ruby using the Rack web API. Very simple. Rack is rad.

# Todo
1. Parameterize the sql query in lib/auth.rb.
2. Nginx auth is incomplete. Documentation is kind of terse. I need to locate a reference implementation.
3. The input validation in lib/validate.rb isn't finished. Currently, all code relating to validation is commented out.
