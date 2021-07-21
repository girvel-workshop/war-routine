local toolkit = {}

local default_represent = {
	repr = function(path)
		return require(path:gsub(".lua", ""):gsub("/", "."))
	end,
	extension = "lua"
}

function toolkit.require_all(directory, parent_represent) -- TODO cache
	local path = directory:gsub("%.", "/")
  if not love.filesystem.getInfo(path) then return end
  
  local module = {}

  local items = love.filesystem.getDirectoryItems(path)

  local represent = #fnl.filter(items, function(value) return value == "_representation.lua" end) > 0 
  	and require(directory .. "._representation")
  	or parent_represent or default_represent
  
  for _, file in ipairs(items) do
  	if not file:starts_with("_") then
  		local value = nil
  		if file:ends_with("." .. represent.extension) then
  			value = represent.repr(path .. "/" .. file)
  		elseif not love.filesystem.getInfo(path .. "/" .. file, 'file') then
  			value = toolkit.require_all(path:gsub("/", ".") .. "." .. file, represent)
  		end
  		module[file:gsub("%.[%w%d]*", "")] = value
  	end
  end

  return module
end

return toolkit