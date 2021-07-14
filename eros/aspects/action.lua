local action = {}

function action:new(name, starting_state, ending_state, event_container)
	obj={
		name = name, 
		starting_state = starting_state, 
		ending_state = ending_state, 
		animation = animation, 
		event_container = event_container or {}
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function action:order(entity)
	if entity.action == false 
			and (entity.cluster[self.starting_state] == entity.sprite 
				or not entity.sprite and not entity.cluster[self.starting_state]) then
		entity.action = tk.copy(self)
		return true
	end
	return false
end

return action