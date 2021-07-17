function eros.load()
  mc = game:add(assets.units.characters.soldier)
  mc.follows = game:add(mc.legs)
  mc.legs = mc.follows

  obj1 = game:add(assets.units.characters.soldier)
  obj1.position = vector:new(200, 0)

  game:add(assets.units.ui.help)

  game.controller.controls = mc

  game.controller.maps.keypressed = {
    q = {assets.actions.arm, assets.actions.disarm},
    r = {assets.actions.reload}
  }

  game.controller.maps.mousepressed = {
    [1] = {assets.actions.fire}
  }

  game.camera.follows = mc
end