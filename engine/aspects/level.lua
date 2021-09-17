local level, module_mt = tk.setmetatable({}, {})

local level_mt = {__index={}}
function module_mt.__call(data)
	return setmetatable({data=data}, level_mt)
end

level_mt.__index.load = function(self)
	log.info "loading level"

	for i, entity_description in ipairs(self.data) do
		game:add(fnl.extend_mut(unpack(entity_description)))
	end

	log.info "level is loaded"
end

return level
