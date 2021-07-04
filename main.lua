vmath = require("vmath")
tiny = require("libraries.tiny")
tk = require("libraries.girvel_toolkit")

tk.require_all("systems")

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
		bullet = load("bullet"),
		magazine = load("magazine"),
		square = load("square"),
		shell = load("shell")
	}

	soldier_cluster = {
		normal = load("soldier_normal"),
		armed = load("soldier_armed")
	}

	mc = {
		cluster = soldier_cluster,
		sprite = soldier_cluster.normal,
		arming_loop = tk.loop:new({soldier_cluster.normal, soldier_cluster.armed}),
		position = vmath.vector:new(400, 300),
		velocity = vmath.vector.zero(),
		fire_source = vmath.vector:new(-54, -16),
		rotation = 0,
		speed = 250,
		run_multiplier = 1.5,
		bullets = tk.limited:new(30),
		bullets_other = 90,
		stamina = tk.limited:new(5),
		action = false,
		fire_time = .12,
		reload_time = 1.5,
		arming_time = 1.3
	}

	controller = {
		controls = mc,
		keyboard_map = {
			q = actions.arm,
			r = actions.reload
		},
		mouse_map = {
			[1] = actions.fire
		}
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
	local a = controller.keyboard_map[key]
	if a then a:order(controller.controls) end
end

function love.mousepressed(x, y, button, istouch)
	local a = controller.mouse_map[button]
	if a then a:order(controller.controls) end
end

function love.draw()
	love.graphics.translate((camera.anchor - camera.position):unpack()) -- TODO camera system

	world:update(0, draw_system_filter)
end