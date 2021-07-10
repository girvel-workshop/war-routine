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

return animation