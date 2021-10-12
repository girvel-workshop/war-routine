local level, module_mt = tk.setmetatable({}, {})

local level_mt = {__index={}}
module_mt.__call = function(_, data)
	return setmetatable({data=data}, level_mt)
end

level_mt.__index.load = function(self)
	log.info("loading level " .. (self.name or ''))

	for _, entity_description in ipairs(self.data) do
		game:add(fnl.extend_mut(unpack(entity_description)))
	end

	game:add(game.main_character)

	log.info "level is loaded"
end

return level
