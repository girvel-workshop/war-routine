function eros.load()
  love.mouse.setCursor(love.mouse.newCursor("assets/sprites/ui/cursor.png"))

  log.trace(inspect(-assets.levels.prototype))
  assets.levels.prototype():load()

  mc = game:create(-assets.units.characters.soldier)

  game.controller.controls = mc

  game.controller.maps.keypressed = {
    q = {-assets.actions.arm, -assets.actions.disarm},
    r = {-assets.actions.reload}
  }

  game.controller.maps.mousepressed = {
    [1] = {-assets.actions.fire}
  }

  game.camera.follows = mc
end