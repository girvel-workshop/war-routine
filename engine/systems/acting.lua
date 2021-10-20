return tiny.processingSystem {
	name = "engine.systems.acting",
	system_type = 'update',
	filter = tiny.requireAll("action"),

	process = function(_, entity, dt)
		local action = entity.action

		if not action then return end

		if action.duration == nil then
			action.duration = limited.minimized(
				action.timeline[0]
					and action.timeline[0](entity)
					 or entity.skills[action.name]
			)

			action.timeline[0] = nil
		end

		local active = action.duration:move(dt)

		-- TODO #optimization order by key to get O(const) instead O(n)
		for moment, event in pairs(action.timeline) do
			if action.duration:fraction() >= moment then
				event(entity)
				action.timeline[moment] = nil
			end
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
}