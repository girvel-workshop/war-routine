return tk.concat(require "assets.units.abstract.physical", {
	sprite = require_all("assets.sprites").items.shell,
	put = function(self, parent)
		self.position = parent.position
	    + (parent.fire_source + (vector:new(math.random(), math.random()) * 2 - vector:one()) * 15)
	    	:rotated(parent.rotation) / 2
	  self.rotation = parent.rotation + 60 * (math.random() * 2 - 1) -- TODO radians
	end
})