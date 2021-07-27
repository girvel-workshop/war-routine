local action = {}

function action:new(behaviour)
	return function(timeline)
		local obj = setmetatable({
			name = behaviour:match("%S+ |"):sub(1, -3),
			starting_state = behaviour:match("| %S+ -"):sub(3, -1),
			ending_state = behaviour:match("> %S+"):sub(3),
			timeline = timeline or {}
		}, action)
		self.__index = self
		return obj
	end
end

function action:order(entity)
	if entity.action == false 
			and (entity.cluster[self.starting_state] == entity.sprite 
				or not entity.sprite and not entity.cluster[self.starting_state]) then
		entity.action = self / fnl.copy()
		return true
	end
	return false
end

return action