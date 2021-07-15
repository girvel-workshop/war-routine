local death_timing = tiny.sortedProcessingSystem()
death_timing.filter = tiny.requireAll("death_delay")

function death_timing:process(entity, dt)
	if not entity.death_delay:move(-dt) then
		game:remove(entity)
	end
end

return death_timing