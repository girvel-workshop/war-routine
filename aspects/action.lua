local action = {}

function action:new(name, starting_state, ending_state, act)
	obj={name = name, starting_state = starting_state, ending_state = ending_state, act = act}
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