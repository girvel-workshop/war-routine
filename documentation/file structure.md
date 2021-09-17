# Main structure

engine PART

- engine/
  - aspects/     -- modules w/ internal functionality
  - devops/      -- development optimization utilities
  - libraries/   -- engine libraries
  - tests        -- engine unit tests
- main.lua       -- main engine script
- conf.lua       -- love2d config file

WAR-ROUTINE PART

- assets/        -- game assets
  - actions/
  - animations/
  - sprites/
  - units/
    - abstract/  -- parent entities
  - weapons/
- bin/           -- project binaries
- documentation/ -- project documentation
  - concepts/    -- future features
- systems/       -- ECS systems declaration
- tests/         -- game unit tests
- game.lua       -- main source file
- conf.lua       -- love2d config file
- README.md      -- readme file

# Local structure

Works in assets/animations, assets/sprites, assets/units

 - characters/
 - items/