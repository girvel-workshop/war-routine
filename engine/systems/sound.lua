return tiny.system {
  name = 'engine.systems.sound',
  system_type = 'update',

  update = function()
    TEsound.cleanup()
  end
}