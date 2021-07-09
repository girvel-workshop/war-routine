fs = require("love.filesystem")
tk = require("libraries.girvel_toolkit")

local animation = {}

function animation:new(name)
	obj = {name = name, frames = {}}

	for _, file in pairs(fs.getDirectoryItems(name)) do
		table.insert(obj.frames, love.graphics.newImage(name .. "/" .. file))
	end

	setmetatable(obj, self)
	self.__index = self
	return obj
end

function animation:animate(entity, duration)
	entity.animation = tk.copy(self)
	entity.animation.duration = tk.limited:new(duration)
end

return animation