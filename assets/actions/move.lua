local function add_footprint(entity)
  local fp = game:add(require("assets.units.footprint"))
  fp.position = tk.copy(entity.position)
  fp.rotation = entity.rotation
end

return (require "eros.aspects.action"):new("move", nil, nil, {
  start = function(entity)
    return 128 / entity.velocity:magnitude()
  end,
  update = function(entity, dt)
    entity.rotation = math.atan2(entity.velocity.y, entity.velocity.x)
  end,
  stop = add_footprint,
  half = add_footprint
})