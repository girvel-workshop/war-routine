local function add_footprint(entity)
  local fp = game:create(-assets.units.footprint)
  fp.position = entity.position / fnl.copy()
  fp.rotation = entity.rotation
end

return engine.aspects.action()[[move | normal -> normal]]({
  [0] = function(entity)
    -- TODO fix this
    assets.sounds().walk:play()
    return 128 / entity.velocity:magnitude() -- TODO refactor
  end,
  [.5] = add_footprint,
  [1] = add_footprint
})