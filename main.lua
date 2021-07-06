tiny = require("libraries.tiny")
tk = require("libraries.girvel_toolkit")
aspects = tk.require_all("aspects")

systems = tk.require_all("systems")

math.randomseed(os.time())

local actions = {
	fire = aspects.action:new("fire", function(entity)
		if entity.sprite ~= entity.cluster.armed or not entity.weapon.bullets:move(-1) then
			return 0
		end

		tiny.add(world, {
			sprite = sprites.shell,
			position = entity.position
			+ (entity.fire_source 
			   + tk.vector:new(math.random() * 2 - 1, math.random() * 2 - 1) * 15
			  ):rotated(entity.rotation) / 2,
			rotation = entity.rotation + 60 * (math.random() * 2 - 1)
		})

		tiny.add(world, {
			sprite = sprites.bullet,
			position = entity.position + entity.fire_source:rotated(entity.rotation),
			rotation = entity.rotation,
			velocity = tk.vector.left():rotated(entity.rotation) * 1000
		})

		entity.animations.fire:animate(entity, entity.weapon.fire_time)

		return entity.weapon.fire_time
	end),
	reload = aspects.action:new("reload", function(entity)
		if entity.sprite ~= entity.cluster.armed or entity.weapon.bullets_other <= 0 then
			return 0
		end

		tiny.add(world, {
			sprite = sprites.magazine,
			position = entity.position 
			+ (entity.fire_source 
			   + tk.vector:new(math.random() * 2 - 1, math.random() * 2 - 1) * 15
			  ):rotated(entity.rotation) / 2
		})

		entity.weapon.bullets.value = math.min(entity.weapon.bullets.limit, entity.weapon.bullets_other)
		entity.weapon.bullets_other = entity.weapon.bullets_other - entity.weapon.bullets.value

		return entity.reload_time
	end),
	arm = aspects.action:new("arm", function(entity)
		entity.sprite = entity.arming_loop:next()

		return entity.arming_time
	end)
}

function load(name)
	return love.graphics.newImage("assets/sprites/" .. name .. ".png")
end

function love.load()
	window_size = tk.vector:new(
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

	-- PRESETS

	sprites = {
		bullet = load("bullet"),
		magazine = load("magazine"),
		square = load("square"),
		shell = load("shell")
	}

	clusters = {
		soldier = {
			normal = load("soldier_normal"),
			armed = load("soldier_armed")
		}
	}

	animations = {
		soldier = {
			fire = aspects.animation:new("soldier_fire", clusters.soldier.armed)
		}
	}

	weapons = {
		default = {
			bullets = tk.limited:new(30),
			bullets_other = 90,
			fire_time = .12
		}
	}

	mc = {
		cluster = clusters.soldier,
		sprite = clusters.soldier.normal,
		arming_loop = tk.loop:new({clusters.soldier.normal, clusters.soldier.armed}),
		position = tk.vector:new(400, 300),
		velocity = tk.vector.zero(),
		fire_source = tk.vector:new(-54, -16),
		rotation = 0,
		speed = 250,
		run_multiplier = 1.5,
		weapon = weapons.default,
		-- bullets = tk.limited:new(30),
		-- bullets_other = 90,
		stamina = tk.limited:new(5),
		action = false,
		-- fire_time = .12,
		reload_time = 1.5,
		arming_time = 1.3,
		animation = false,
		animations = animations.soldier
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

	mc.velocity = tk.vector.zero()

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