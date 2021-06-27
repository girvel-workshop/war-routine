require("vmath")
tiny = require("libraries.tiny")
require("systems.drawing")

draw_system_filter = tiny.requireAll("is_drawing_system")
update_system_filter = tiny.rejectAll("is_drawing_system")

function love.load()
	world = tiny.world(
		drawing
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
		stamina = 5,
		stamina_max = 5
	}

	tiny.add(world, mc)

	bullets = {}
end

function love.update(dt)
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
		if mc.stamina > 0 then 
			mc.velocity = mc.velocity * mc_run_multiplier
			mc.stamina = mc.stamina - dt
		end
	else
		mc.stamina = mc.stamina + dt
	end

	mc.position = mc.position + mc.velocity * dt

	-- MOUSE

	local mx, my = love.mouse.getPosition()
	mc.rotation = math.atan2(mc.position.y - my, mc.position.x - mx)

	-- BULLETS

	for i, b in ipairs(bullets) do 
		b.position = b.position - vector.right():rotated(b.rotation) * bullet_speed * dt
	end
end

function love.keypressed(key)
	-- ARM / DISARM

	if key == "q" then
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
		b = {
			sprite = sprites.bullet,
			position = mc.position + mc.fire_source:rotated(mc.rotation),
			rotation = mc.rotation
		}
		table.insert(bullets, b)
		tiny.add(world, b)
		mc.bullets = mc.bullets - 1
	end
end

function love.draw()
	world:update(0, draw_system_filter)
end