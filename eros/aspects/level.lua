local level = {}

function level:new(data)
	return {data = data} / fnl.inherit(self)
end

function level:load()
	log.info[[loading level]]

	log.trace("data", inspect(self.data))

	for i, entity_description in ipairs(self.data) do
		local entity, changes = unpack(entity_description)
		game:add(fnl.extend(entity, changes))
	end

	log.info[[level is loaded]]
end

return level