local soundpack, module_mt = tk.setmetatable({}, {})

module_mt.__call = function(path)
  local obj = {
    path = path,
    sounds = {}
  }

  for _, file in pairs(love.filesystem.getDirectoryItems(path)) do
    table.insert(
      obj.sounds, 
      love.sound.newSoundData(path .. "/" .. file)
    )
  end

  return setmetatable(obj, {__index={
    play=function(self) TEsound.play(self.sounds, "static")  end
  }})
end

return soundpack