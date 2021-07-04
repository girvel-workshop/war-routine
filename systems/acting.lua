tiny = require("libraries.tiny")
tk = require("libraries.girvel_toolkit")

-- LOCAL TOOLKIT

action = {}

function action:new(name, act)
	obj={name = name, act = act}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function action:order(entity)
	if entity.action == false then
		entity.action = copy(self)
	end
end

actions = {
	fire = action:new("fire", function(entity)
		if entity.sprite ~= entity.cluster.armed or not entity.bullets:move(-1) then
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

		return entity.fire_time
	end),
	reload = action:new("reload", function(entity)
		if entity.sprite ~= entity.cluster.armed or entity.bullets_other <= 0 then
			return action_delay
		end

		tiny.add(world, {
			sprite = sprites.magazine,
			position = entity.position + entity.fire_source:rotated(entity.rotation) / 2
		})

		entity.bullets.value = math.min(entity.bullets.limit, entity.bullets_other)
		entity.bullets_other = entity.bullets_other - entity.bullets.value

		return entity.reload_time
	end),
	arm = action:new("arm", function(entity)
		entity.sprite = entity.arming_loop:next()

		return entity.arming_time
	end)
}

-- SYSTEM

acting = tiny.processingSystem()
acting.filter = tiny.requireAll("action")

action_delay = .1

function acting:process(entity, dt)
	if entity.action == false then return end

	if entity.action.duration == nil then
		entity.action.duration = tk.limited:new(entity.action.act(entity))
	end

	if not entity.action.duration:move(-dt) then
		entity.action = false
	end
end