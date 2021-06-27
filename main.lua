function draw_image_centralized(image, x, y, r)
	love.graphics.draw(image, x, y, r, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
end

vector = {}

function vector:new(x, y)
	local v={x=x, y=y}
	setmetatable(v, self)
	self.__index = self
	return v
end

vector.zero = vector:new(0, 0)

function love.load()
	soldier_normal = love.graphics.newImage("assets/sprites/soldier.png")
	soldier_armed = love.graphics.newImage("assets/sprites/soldier - armed.png")
	bullet = love.graphics.newImage("assets/sprites/bullet.png")

	bullet_speed = 1000

	mc_velocity = vector:new(0, 0)

	mc_x = 400
	mc_y = 300
	mc_rotation = 0
	mc_speed = 250
	mc_run_multiplier = 1.5
	mc_image = soldier_normal
	mc_fire_source_x = -54
	mc_fire_source_y = -16
	mc_bullets = 30
	mc_bullets_max = 30
	mc_bullets_other = 90
	mc_stamina = 5
	mc_stamina_max = 5

	bullets = {}
end

function love.update(dt)
	-- MOVEMENT

	mc_velocity = vector:new(0, 0)

	if love.keyboard.isDown("w") then
		mc_velocity.y = -mc_speed
	end
	if love.keyboard.isDown("s") then
		mc_velocity.y = mc_speed
	end
	if love.keyboard.isDown("a") then
		mc_velocity.x = -mc_speed
	end
	if love.keyboard.isDown("d") then
		mc_velocity.x = mc_speed
	end

	if love.keyboard.isDown("lshift") then 
		if mc_stamina > 0 then 
			mc_velocity.x = mc_velocity.x * mc_run_multiplier
			mc_velocity.y = mc_velocity.y * mc_run_multiplier
			mc_stamina = mc_stamina - dt
		end
	else
		mc_stamina = mc_stamina + dt
	end

	mc_x = mc_x + mc_velocity.x * dt
	mc_y = mc_y + mc_velocity.y * dt

	-- MOUSE

	local mx, my = love.mouse.getPosition()
	mc_rotation = math.atan2(mc_y - my, mc_x - mx)

	-- BULLETS

	for i, b in ipairs(bullets) do 
		b.x = b.x - math.cos(b.r) * bullet_speed * dt
		b.y = b.y - math.sin(b.r) * bullet_speed * dt
	end
end

function love.keypressed(key)
	-- ARM / DISARM

	if key == "q" then
		if mc_image == soldier_normal then
			mc_image = soldier_armed
		else
			mc_image = soldier_normal
		end
	end

	if key == 'r' then
		mc_bullets = math.min(mc_bullets_max, mc_bullets_other)
		mc_bullets_other = mc_bullets_other - mc_bullets
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 and mc_image == soldier_armed and mc_bullets > 0 then
		table.insert(bullets, {
			x=mc_x + math.cos(mc_rotation) * mc_fire_source_x - math.sin(mc_rotation) * mc_fire_source_y, 
			y=mc_y + math.sin(mc_rotation) * mc_fire_source_x + math.cos(mc_rotation) * mc_fire_source_y, 
			r=mc_rotation
		})
		mc_bullets = mc_bullets - 1
	end
end

function love.draw()
	love.graphics.setBackgroundColor(.75, .75, .75)
	draw_image_centralized(mc_image, mc_x, mc_y, mc_rotation)

	for i, b in ipairs(bullets) do 
		draw_image_centralized(bullet, b.x, b.y, b.r)
	end
end