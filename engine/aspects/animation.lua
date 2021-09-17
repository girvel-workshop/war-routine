local animation, module_mt = tk.setmetatable({}, {})

module_mt.__call = function(self, name)
	obj = {name = name, frames = {}}

	for _, file in pairs(love.filesystem.getDirectoryItems(name)) do
		table.insert(obj.frames, love.graphics.newImage(name .. "/" .. file))
	end

	setmetatable(obj, self)
	self.__index = self
	return obj
end

return animation