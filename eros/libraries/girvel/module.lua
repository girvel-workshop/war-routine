local module = {}

function module:new(path)
	return fnl.inherit(self, {path = path})
end

function module:__unm()
	if love.filesystem.getInfo(tk.to_posix(self.path), 'directory') then
    return tk.require_all(self.path)
  end
  return tk.require(self.path)
end

function module:__call()
	return -self
end

return module