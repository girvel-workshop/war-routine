local function add_footprint(entity)
  local fp = game:add(require("assets.units.footprint"))
  fp.position = tk.copy(entity.position)
  fp.rotation = entity.rotation
end

return aspects.action:new[[move | normal -> normal]]({
  [0] = function(entity)
    return 128 / entity.velocity:magnitude() -- TODO refactor
  end,
  [.5] = add_footprint,
  [1] = add_footprint
})