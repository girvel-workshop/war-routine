return fnl.extend(-eros.units.physical, {
	sprite = -assets.sprites.items.bullet,
	layer = assets.config.layers().on_floor,
	radius = 2,
	damage = 100,
	fire_from = function(self, parent)
		self.position = parent.position + parent.fire_source:rotated(parent.rotation)
    self.rotation = parent.rotation
    self.velocity = vector.up():rotated(parent.rotation) * parent.weapon.power
	end
})