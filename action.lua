local action = {}

function action:new(name, act)
	obj={name = name, act = act}
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