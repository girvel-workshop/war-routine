vmath = require("vmath")
tiny = require("libraries.tiny")
tk = require("libraries.girvel_toolkit")

tk.require_all("systems")

action = {}

function action:new(name, duration)
	obj={name = name, duration = duration}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

actions = {
	fire = action:new("fire", tk.limited:new(0.3))
}

draw_system_filter = tiny.requireAll("drawing_system_flag")
update_system_filter = tiny.rejectAll("drawing_system_flag")

function load(name)
	return love.graphics.newImage("assets/sprites/" .. name .. ".png")
end

function love.load()
	window_size = vmath.vector:new(
		love.graphics.getWidth(),
		love.graphics.getHeight()
	)

	world = tiny.world(
		drawing,
		moving,
		following,
		acting
	)

	sprites = {
		soldier_normal = load("soldier_normal"),
		soldier_armed = load("soldier_armed"),
		bullet = load("bullet"),
		magazine = load("magazine"),
		square = load("square"),
		shell = load("shell")
	}

	mc = {
		sprite = sprites.soldier_normal,
		arming_loop = tk.loop:new({sprites.soldier_normal, sprites.soldier_armed}),
		position = vmath.vector:new(400, 300),
		velocity = vmath.vector.zero(),
		fire_source = vmath.vector:new(-54, -16),
		rotation = 0,
		speed = 250,
		run_multiplier = 1.5,
		bullets = tk.limited:new(30),
		bullets_other = 90,
		stamina = tk.limited:new(5),
		action = false
	}

	camera = {
		follows = mc,
		anchor = window_size / 2,
	}

	tiny.add(world, camera)
	tiny.add(world, mc)
end

function love.update(dt)
	world:update(dt, update_system_filter)

	-- MOVEMENT

	mc.velocity = vmath.vector.zero()

	if love.keyboard.isDown("w") then -- TODO REFACTOR
		mc.velocity.y = -mc.speed
	end
	if love.keyboard.isDown("s") then
		mc.velocity.y = mc.speed
	end
	if love.keyboard.isDown("a") then
		mc.velocity.x = -mc.speed
	end
	if love.keyboard.isDown("d") then
		mc.velocity.x = mc.speed
	end

	if love.keyboard.isDown("lshift") then 
		if mc.stamina:move(-dt) then
			mc.velocity = mc.velocity * mc.run_multipler
		end
	else
		mc.stamina:move(dt)
	end

	-- MOUSE

	local mx, my = love.mouse.getPosition()
	mc.rotation = math.atan2(window_size.y / 2 - my, window_size.x / 2 - mx)
end

function love.keypressed(key)
	-- ARM / DISARM

	if key == "q" then -- loop class
		mc.sprite = mc.arming_loop:next()
	end

	if key == 'r' and mc.sprite == sprites.soldier_armed and mc.bullets_other > 0 then
		tiny.add(world, {
			sprite = sprites.magazine,
			position = mc.position + mc.fire_source:rotated(mc.rotation) / 2
		})

		mc.bullets.value = math.min(mc.bullets.limit, mc.bullets_other)
		mc.bullets_other = mc.bullets_other - mc.bullets.value
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 and mc.sprite == sprites.soldier_armed and mc.bullets:move(-1) then
		mc.action = copy(actions.fire)
	end
end

function love.draw()
	love.graphics.translate((camera.anchor - camera.position):unpack())

	world:update(0, draw_system_filter)
end