tiny = require("libraries.tiny")
tk = require("libraries.girvel_toolkit")

-- LOCAL TOOLKIT

action = {}

function action:new(name)
	obj={name = name}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function action:order(entity)
	print("Current order is", entity.action)
	if entity.action == false then
		entity.action = copy(self)
	end
end

actions = {
	fire = action:new("fire")
}

-- SYSTEM

acting = tiny.processingSystem()
acting.filter = tiny.requireAll("action")

action_delay = .1

local actions = {
	fire = function(entity)
		if entity.sprite ~= entity.cluster.armed or not mc.bullets:move(-1) then
			return action_delay
		end

		tiny.add(world, {
			sprite = sprites.shell,
			position = entity.position + entity.fire_source:rotated(entity.rotation) / 2,
			rotation = entity.rotation
		})

		tiny.add(world, {
			sprite = sprites.bullet,
			position = entity.position + entity.fire_source:rotated(entity.rotation),
			rotation = entity.rotation,
			velocity = vmath.vector.left():rotated(entity.rotation) * 1000
		})

		print(entity.fire_time)
		return entity.fire_time
	end,
	reload = function(entity)

	end
}

function acting:process(entity, dt)
	if entity.action == false then return end

	local act = actions[entity.action.name]
	if act then
		if entity.action.duration == nil then
			entity.action.duration = tk.limited:new(act(entity))
		end

		if not entity.action.duration:move(-dt) then
			entity.action = false
		end
	end
end