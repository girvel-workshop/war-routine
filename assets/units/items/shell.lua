return -engine.units.physical / fnl.extend{
	name = "items.shell",
	sprite = -assets.sprites.items.shell,
	layer = assets.config.layers().on_floor,
	put_near = function(self, parent)
		self.position = parent.position
	    + ((vector(math.random(), math.random()) * 2 - vector.one) * 15):rotated(parent.rotation) * .5
	  self.rotation = parent.rotation + math.pi / 3 * (math.random() * 2 - 1)
	end
}