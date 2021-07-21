function eros.load()
  love.mouse.setCursor(love.mouse.newCursor("assets/sprites/ui/cursor.png"))

  mc = game:create(assets.units.characters.soldier)

  obj1 = game:create(assets.units.characters.soldier)
  obj1.legs.position = vector:new(200, 0)

  game:create(assets.units.ui.help)

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