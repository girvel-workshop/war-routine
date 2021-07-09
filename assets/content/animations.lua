aspects = require_all("aspects")
return aspects.container:new("assets/animations", "anm", function(path) return aspects.animation:new(path) end)