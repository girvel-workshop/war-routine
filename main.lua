vmath = require("vmath")
tiny = require("libraries.tiny")
toolkit = require("libraries.girvel_toolkit")

toolkit.require_all("systems")

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
		arming_loop = toolkit.loop:new({sprites.soldier_normal, sprites.soldier_armed}),
		position = vmath.vector:new(400, 300),
		velocity = vmath.vector.zero(),
		fire_source = vmath.vector:new(-54, -16),
		rotation = 0,
		speed = 250,
		run_multiplier = 1.5,
		bullets = toolkit.limited:new(30),
		bullets_other = 90,
		stamina = toolkit.limited:new(5)
	}

	tiny.add(world, mc)
	tiny.add(world, {

	})

	bullets = {}
end

function love.update(dt)
	world:update(dt, update_system_filter)

	-- MOVEMENT

	mc.velocity = vmath.vector.zero()

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
		if mc.stamina:move(-dt) then
			mc.velocity = mc.velocity * mc.run_multipler
		end
	else
		mc.stamina:move(dt)
	end

	-- MOUSE

	local mx, my = love.mouse.getPosition()
	mc.rotation = math.atan2(mc.position.y - my, mc.position.x - mx)
end

function love.keypressed(key)
	-- ARM / DISARM

	if key == "q" then -- loop class
		mc.sprite = mc.arming_loop:next()
	end

	if key == 'r' then
		mc.bullets.value = math.min(mc.bullets.limit, mc.bullets_other)
		mc.bullets_other = mc.bullets_other - mc.bullets.value
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 and mc.sprite == sprites.soldier_armed and mc.bullets:move(-1) then
		tiny.add(world, {
			sprite = sprites.bullet,
			position = mc.position + mc.fire_source:rotated(mc.rotation),
			rotation = mc.rotation,
			velocity = vmath.vector.left():rotated(mc.rotation) * bullet_speed
		})
	end
end

function love.draw()
	world:update(0, draw_system_filter)
end