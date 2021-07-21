local soundpack = {}

function soundpack:new(path)
  obj = {
    path = path,
    sounds = {}
  }

  for _, file in pairs(love.filesystem.getDirectoryItems(path)) do
    table.insert(
      obj.sounds, 
      love.sound.newSoundData(path .. "/" .. file)
    )
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

function soundpack:play()
  TEsound.play(self.sounds, "static")
end

return soundpack