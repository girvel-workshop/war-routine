local acting = tiny.processingSystem()
acting.filter = tiny.requireAll("action")

function acting:process(entity, dt)
	if entity.action == false then return end

	if entity.action.duration == nil then
		entity.action.duration = tk.limited:new(entity.action.event_container.start
			and entity.action.event_container.start(entity)
			 or entity.skills[entity.action.name])
	end

	local was_more_than_half = entity.action.duration:fraction() > 0.5

	if not entity.action.duration:move(-dt) then
    entity.sprite = entity.cluster[entity.action.ending_state]
    
    local stop = entity.action.event_container.stop
    if stop then stop(entity) end
    
		entity.action = false
		entity.animation = false
	else
		if entity.action.event_container.update then
    	entity.action.event_container.update(entity, dt)
  	end

  	if was_more_than_half and entity.action.duration:fraction() <= 0.5 then
  		local half = entity.action.event_container.half
  		if half then
  			half(entity)
  		end
  	end

  	if entity.action.name then 
  		local animation = entity.animations[entity.action.name]
  		if animation then 
	  		local fr = 1 - entity.action.duration:fraction()

				entity.sprite = animation.frames[math.ceil(fr * #animation.frames)]
			end
  	end
  end
end

return acting