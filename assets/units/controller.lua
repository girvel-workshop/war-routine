return -engine.units.entity/fnl.extend {
  name = 'assets.units.controller',
  controls = false,
  control_maps = {
    keypressed = {
      q = {-assets.actions.arm, -assets.actions.disarm},
      r = {-assets.actions.reload}
    },

    mousepressed = {
      [1] = {-assets.actions.fire}
    }
  }
}