local toolkit = {}

local default_represent = {
	repr = function(path)
		return require(path:gsub(".lua", ""):gsub("/", "."))
	end,
	extension = "lua"
}

local cache = {} -- TODOLONG cache to decorator

function toolkit.require_all(directory, _parent_represent) -- TODO cache
	local path = directory:gsub("%.", "/")
  if not love.filesystem.getInfo(path) then return end

  if cache[directory] then return cache[directory] end
  
  local module = {}

  local items = love.filesystem.getDirectoryItems(path)

  local represent = fnl.contains(items, "_representation.lua")
  	and require(directory .. "._representation")
  	or _parent_represent or default_represent
  
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

  cache[directory] = module
  return module
end

function toolkit.require(filepath, _parent_represent)
  if not cache[filepath] then -- TODOLONG cache decorator
    local path = ""
    local represent = default_represent

    for i, element in ipairs(filepath / ".") do
      path = i == 1 and element or (path .. "." .. element)
      
      represent = love.filesystem.getInfo(path:gsub("%.", "/") + "/_representation.lua") 
        and require(path + "._representation")
         or represent
    end

    cache[filepath] = represent.repr(filepath:gsub("%.", "/") .. "." .. represent.extension)
  end
  return cache[filepath]
end

function toolkit.entity(parent_path)
  return function(table)
    return fnl.extend(require(parent_path), table)
  end
end

return toolkit