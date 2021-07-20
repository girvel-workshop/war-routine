local acting = tiny.processingSystem()
acting.filter = tiny.requireAll("action")

function acting:process(entity, dt)
	local action = entity.action

	if not action then return end

	if action.duration == nil then
		action.duration = tk.limited:empty(
			action.timeline[0]
				and action.timeline[0](entity)
				 or entity.skills[action.name]
		)

		action.timeline[0] = nil
	end

	local active = action.duration:move(dt)

	for moment, event in pairs(action.timeline) do
		if action.duration:fraction() < moment then
			break
		end

		event(entity)
		action.timeline[moment] = nil
	end

	if active then
		if action.timeline.update then
    	action.timeline.update(entity, dt)
  	end

  	if action.name then 
  		local animation = entity.animations[action.name]
  		if animation then 
	  		local fr = action.duration:fraction()

				entity.sprite = animation.frames[math.ceil(fr * #animation.frames)]
			end
  	end
	else
    entity.sprite = entity.cluster[action.ending_state]
    
		entity.action = false
		entity.animation = false
  end
end

return acting