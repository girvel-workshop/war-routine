return fnl.extend(require "assets.units.abstract.physical", {
	sprite = require_all("assets.sprites").items.magazine,
	layer = require("assets.config.layers").on_floor,
	put_near = function(self, parent)
		self.position = parent.position 
	    + (parent.fire_source 
	       + vector:new(math.random() * 2 - 1, math.random() * 2 - 1) * 15
	      ):rotated(parent.rotation) / 2
	  self.rotation = math.random() * 6.28
	end
})