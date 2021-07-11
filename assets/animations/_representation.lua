local aspects = require_all("aspects")
return {
	folder = function(path)
		if tk.endswith(path, "anm") then
			return aspects.animation.new(path)
		end

		return require_all(path)
		
	end
	aspects.container:new("assets/animations", "anm", function(path) return aspects.animation:new(path) end)
}