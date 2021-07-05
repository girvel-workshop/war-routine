vmath = require("vmath")
tiny = require("libraries.tiny")
tk = require("libraries.girvel_toolkit")
action = require("action")
animation = require("animation")

systems = tk.require_all("systems")

math.randomseed(os.time())

local actions = {
	fire = action:new("fire", function(entity)
		if entity.sprite ~= entity.cluster.armed or not entity.bullets:move(-1) then
			return 0
		end

		tiny.add(world, {
			sprite = sprites.shell,
			position = entity.position
			+ (entity.fire_source 
			   + vmath.vector:new(math.random() * 2 - 1, math.random() * 2 - 1) * 15
			  ):rotated(entity.rotation) / 2,
			rotation = entity.rotation + 60 * (math.random() * 2 - 1)
		})

		tiny.add(world, {
			sprite = sprites.bullet,
			position = entity.position + entity.fire_source:rotated(entity.rotation),
			rotation = entity.rotation,
			velocity = vmath.vector.left():rotated(entity.rotation) * 1000
		})

		entity.animations.fire:animate(entity, entity.fire_time)

		return entity.fire_time
	end),
	reload = action:new("reload", function(entity)
		if entity.sprite ~= entity.cluster.armed or entity.bullets_other <= 0 then
			return 0
		end

		tiny.add(world, {
			sprite = sprites.magazine,
			position = entity.position 
			+ (entity.fire_source 
			   + vmath.vector:new(math.random() * 2 - 1, math.random() * 2 - 1) * 15
			  ):rotated(entity.rotation) / 2
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

function load(name)
	return love.graphics.newImage("assets/sprites/" .. name .. ".png")
end

function love.load()
	window_size = vmath.vector:new(
		love.graphics.getWidth(),
		love.graphics.getHeight()
	)

	world = tiny.world(
		systems.animation,
		systems.drawing,
		systems.moving,
		systems.following,
		systems.acting
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

	soldier_animations = {
		fire = animation:new("soldier_fire", soldier_cluster.armed)
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
		arming_time = 1.3,
		animation = false,
		animations = soldier_animations
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
		follows = controller.controls,
		position = controller.controls.position,
		anchor = window_size / 2,
	}

	tiny.add(world, camera)
	tiny.add(world, mc)
end

function love.update(dt)
	world:update(dt, tiny.rejectAll("drawing_system_flag"))

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

	world:update(0, tiny.requireAll("drawing_system_flag"))
end