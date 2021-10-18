local action, module_mt = tk.setmetatable({}, {})

local action_mt = {__index={}}

module_mt.__call = function(_, behaviour)
	return function(timeline)
		return setmetatable({
			name = behaviour:match("%S+ |"):sub(1, -3),
			starting_state = behaviour:match("| %S+ -"):sub(3, -1),
			ending_state = behaviour:match("> %S+"):sub(3),
			timeline = timeline or {}
		}, action_mt)
	end
end

action_mt.__index.order = function(self, entity)
	if entity.action == false 
			and (entity.cluster[self.starting_state] == entity.sprite 
				or not entity.sprite and not entity.cluster[self.starting_state]) then
		entity.action = self/fnl.copy()
		return true
	end
	return false
end

return action