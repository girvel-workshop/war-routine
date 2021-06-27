require "love.filesystem"

function require_all(directory)
	for _, lua in ipairs(love.filesystem.getDirectoryItems(directory)) do
		require("systems." .. string.gsub(lua, ".lua", ""))
	end
end