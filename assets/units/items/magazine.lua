return -engine.units.physical / fnl.extend{
	name = "items.magazine",
	sprite = -assets.sprites.items.magazine,
	layer = assets.config.layers().on_floor,
	put_near = function(self, parent)
		self.position = parent.position 
	    + (parent.fire_source 
	       + vector(math.random() * 2 - 1, math.random() * 2 - 1) * 15
	      ):rotated(parent.rotation) * .5
	  self.rotation = math.random() * 6.28
	end
}