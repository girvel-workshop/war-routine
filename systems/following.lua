local following = tiny.processingSystem()
following.filter = tiny.requireAll("follows")

function following:process(e, _)
	e.position = e.follows.position
end

return following