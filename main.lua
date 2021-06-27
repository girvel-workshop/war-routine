require("vmath")
tiny = require("libraries.tiny")
require("libraries.girvel_toolkit")
require_all("systems")

draw_system_filter = tiny.requireAll("is_drawing_system")
update_system_filter = tiny.rejectAll("is_drawing_system")

function love.load()
	world = tiny.world(
		drawing,
		moving
	)

	sprites = {
		soldier_normal = love.graphics.newImage("assets/sprites/soldier.png"),
		soldier_armed = love.graphics.newImage("assets/sprites/soldier - armed.png"),
		bullet = love.graphics.newImage("assets/sprites/bullet.png")
	}
	
	bullet_speed = 1000

	mc = {
		sprite = sprites.soldier_normal,
		position = vector:new(400, 300),
		velocity = vector.zero(),
		fire_source = vector:new(-54, -16),
		rotation = 0,
		speed = 250,
		run_multiplier = 1.5,
		bullets = 30,
		bullets_max = 30,
		bullets_other = 90,
		stamina = limited:new(5)
	}

	tiny.add(world, mc)

	bullets = {}
end

function love.update(dt)
	world:update(dt, update_system_filter)

	-- MOVEMENT

	mc.velocity = vector.zero()

	if love.keyboard.isDown("w") then
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
		if mc.stamina.value > 0 then 
			mc.velocity = mc.velocity * mc.run_multiplier
			mc.stamina.value = math.max(0, mc.stamina.value - dt)
		end
	else
		mc.stamina.value = math.min(mc.stamina.limit, mc.stamina.value + dt)
	end

	-- MOUSE

	local mx, my = love.mouse.getPosition()
	mc.rotation = math.atan2(mc.position.y - my, mc.position.x - mx)
end

function love.keypressed(key)
	-- ARM / DISARM

	if key == "q" then -- loop class
		if mc.sprite == sprites.soldier_normal then
			mc.sprite = sprites.soldier_armed
		else
			mc.sprite = sprites.soldier_normal
		end
	end

	if key == 'r' then
		mc.bullets = math.min(mc.bullets_max, mc.bullets_other)
		mc.bullets_other = mc.bullets_other - mc.bullets
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 and mc.sprite == sprites.soldier_armed and mc.bullets > 0 then
		tiny.add(world, {
			sprite = sprites.bullet,
			position = mc.position + mc.fire_source:rotated(mc.rotation),
			rotation = mc.rotation,
			velocity = vector.left():rotated(mc.rotation) * bullet_speed
		})
		mc.bullets = mc.bullets - 1
	end
end

function love.draw()
	world:update(0, draw_system_filter)
end