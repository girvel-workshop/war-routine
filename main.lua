require "vmath"

function draw_image_centralized(image, p, r)
	love.graphics.draw(image, p.x, p.y, r, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
end

function love.load()
	soldier_normal = love.graphics.newImage("assets/sprites/soldier.png")
	soldier_armed = love.graphics.newImage("assets/sprites/soldier - armed.png")
	bullet = love.graphics.newImage("assets/sprites/bullet.png")

	bullet_speed = 1000

	mc = {
		image=soldier_normal,
		position = vector:new(400, 300),
		velocity = vector.zero(),
		fire_source = vector:new(-54, -16),
		rotation = 0,
		speed = 250,
		run_multiplier = 1.5,
		bullets = 30,
		bullets_max = 30,
		stamina = 5,
		stamina_max = 5
	}

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
		b.position = b.position - vector.right():rotated(b.r) * bullet_speed * dt
	end
end

function love.keypressed(key)
	-- ARM / DISARM

	if key == "q" then
		if mc.image == soldier_normal then
			mc.image = soldier_armed
		else
			mc.image = soldier_normal
		end
	end

	if key == 'r' then
		mc.bullets = math.min(mc.bullets_max, mc.bullets_other)
		mc.bullets_other = mc.bullets_other - mc.bullets
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 and mc.image == soldier_armed and mc.bullets > 0 then
		table.insert(bullets, {
			position = mc.position + mc.fire_source:rotated(mc.rotation),
			r = mc.rotation
		})
		mc.bullets = mc.bullets - 1
	end
end

function love.draw()
	love.graphics.setBackgroundColor(.75, .75, .75)
	draw_image_centralized(mc.image, mc.position, mc.rotation)

	for i, b in ipairs(bullets) do 
		draw_image_centralized(bullet, b.position, b.r)
	end
end