function engine.load()
  love.mouse.setCursor(love.mouse.newCursor("assets/sprites/ui/cursor.png"))

  assets.levels.prototype():load()

  local mc = game:create(-assets.units.characters.soldier)

  game.controller.controls = mc

  game.camera.follows = mc
end