local following = tiny.processingSystem()
following.filter = tiny.requireAll("follows")

function following:process(e, _)
	if not e.follows then return end

	e.position = e.follows.position
end

return following