local pegasus = require "pegasus"

local dir = "./"
if (args) then dir = args[1] end

local server = pegasus:new({
	port = '9090',
	location = dir
})

lush.exec("firefox localhost:9090 &; clear")
server:start(function(request, response)
	print "Serving files..."
end)
