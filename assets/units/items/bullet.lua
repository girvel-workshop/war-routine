return -engine.units.physical/fnl.extend{
	name = "items.bullet",
	sprite = -assets.sprites.items.bullet,
	layer = assets.config.layers().on_floor,
	radius = 2,
	damage = 100,
	fire_from = function(self, parent)
		self.position = parent.position
    self.rotation = parent.rotation
    self.velocity = vector.up:rotated(parent.rotation) * parent.power
	end
}