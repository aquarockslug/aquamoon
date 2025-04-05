local pegasus = require 'pegasus'

local server = pegasus:new({
  port='9090',
  location='./'
})

server:start(function (request, response)
  print "Server running on localhost:9090"
end)
