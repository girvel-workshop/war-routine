describe("ecs framework", function()
  package.path = '?.lua;framework/?.lua;lib/?.lua'
  package.cpath = ''
  local ecs = require 'ecs'

  describe("locals", function()
    describe("iterate_targets", function()
      it("should iterate through all the targets", function()
        local targets = {
          x = {1, 2},
          y = {3, 6}
        }

        local result = {}
        for members in ecs.locals.iterate_targets(targets) do
          table.insert(result, members)
        end

        assert.are_same(
          {
            {x = 1, y = 3},
            {x = 1, y = 6},
            {x = 2, y = 3},
            {x = 2, y = 6},
          },
          result
        )
      end)
    end)

    describe("add", function()
      it("should try to register entity", function()
        local it_works = false

        local entity = {
          name = 'an entity',
          size = 22,
          form_type = 'A',
        }

        local system = ecs.make_system {
          filters = {
            entity = {components = {'name', 'size'}}
          },

          register = function(_, e)
            it_works = e == entity
          end
        }

        ecs.locals.add(system, entity)
        assert.is_true(it_works)
      end)
    end)
  end)

  describe("ECS itself", function()
    it("works", function()
      local moving_entities_n = 0

      local ms = ecs.make_metasystem {}

      ms:add(ecs.make_system {
        name = 'testing.systems.movement',
        filters = {
          moving = {components = {'position', 'velocity'}}
        },
        register = function()
          moving_entities_n = moving_entities_n + 1
        end,
        process = function(_, members, delta)
          members.moving.position = members.moving.position + members.moving.velocity * delta.time
        end
      })

      local e1 = ms:add {position = 0, velocity = 10}
      local e2 = ms:add {position = -10, velocity = 5}
      local e3 = ms:add {position = 0}

      ms:update {time = 10}
      ms:update {time = -1}

      assert.are_equal(2, moving_entities_n)
      assert.are_same({position = 90, velocity = 10}, e1)
      assert.are_same({position = 35, velocity = 5}, e2)
      assert.are_same({position = 0}, e3)
    end)
  end)

  --describe("system", function()
  --  it("should iterate through all the entities", function()
  --    local entities = {
  --      {id = 1}, {id = 2}, {id = 3}
  --    }
  --
  --    local clock = ecs.clock()
  --
  --    for _, e in ipairs(entities) do
  --      clock.add(e)
  --    end
  --
  --    local entities_order = {}
  --
  --    clock.add(ecs.system {
  --      filters = {
  --        first = {components={'id'}},
  --        second = {components={'id'}},
  --      },
  --
  --      process = function(members, delta)
  --        table.insert(entities_order, {members.first.id, members.second.id, delta})
  --      end
  --    })
  --
  --    clock.update(0)
  --
  --    assert.are_same(
  --      {
  --        {1, 1, 0}, {1, 2, 0}, {1, 3, 0},
  --        {2, 1, 0}, {2, 2, 0}, {2, 3, 0},
  --        {3, 1, 0}, {3, 2, 0}, {3, 3, 0},
  --      },
  --      entities_order
  --    )
  --  end)
  --end)
end)