tiny = require("libraries.tiny")
tools = require("tools")

following = tiny.processingSystem()
following.filter = tiny.requireAll("follows")

function following:process(e, _)
	e.position = e.follows.position
end