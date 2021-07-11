return tk.concat(require "assets.units.abstract.physical", {
	sprite = require_all("assets.sprites").bullet,
	fire = function(self, parent)
		self.position = parent.position + parent.fire_source:rotated(parent.rotation)
    self.rotation = parent.rotation
    self.velocity = vector.left():rotated(parent.rotation) * parent.weapon.power
	end
})