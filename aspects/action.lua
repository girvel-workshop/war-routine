local action = {}

function action:new(name, starting_state, ending_state, animation, event_container)
	obj={name = name, starting_state = starting_state, ending_state = ending_state, animation = animation, event_container = event_container}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function action:order(entity)
	if entity.action == false then
		entity.action = copy(self)
	end
end

return action