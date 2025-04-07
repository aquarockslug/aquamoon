local pegasus = require 'pegasus'

local server = pegasus:new({
	port = '9090',
	location = args[1]
})

server:start(function(request, response)
	print "Serving files..."
end)

lush.exec("firefox localhost:9090")
