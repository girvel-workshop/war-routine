local container = {}

function container:new(folder, extension, converter)
	local obj = {folder = folder, extension = extension, converter = converter}
	setmetatable(obj, self)
	return obj
end

function container:__index(key)
  local value = self.converter(self.folder .. "/" .. key .. "." .. self.extension)
  rawset(self, key, value)
  return value
end

return container