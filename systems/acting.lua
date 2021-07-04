tiny = require("libraries.tiny")
tk = require("libraries.girvel_toolkit")

local acting = tiny.processingSystem()

acting.filter = tiny.requireAll("action")

local action_delay = .1

function acting:process(entity, dt)
	if entity.action == false then return end

	if entity.action.duration == nil then
		entity.action.duration = tk.limited:new(entity.action.act(entity))
	end

	if not entity.action.duration:move(-dt) then
		entity.action = false
	end
end

return acting