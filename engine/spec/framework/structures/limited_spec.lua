describe("limited structure", function()
  local limited = require 'structures.limited'

  describe("creation function", function()
    it("creates limited value", function()
      local ltd = limited(1, 0, 3)
      assert.are.same({value=1, min=0, max=3}, ltd)
    end)
  end)

  describe("move method", function()
    it("tries to move value and returns true if there were any changes", function()
      local ltd = limited(1, 0, 2)

      assert.is_true(ltd:move(1.5))
      assert.are_equal(ltd.value, 2)
      assert.is_false(ltd:move(1))

      assert.is_true(ltd:move(-3))
      assert.are_equal(ltd.value, 0)
      assert.is_false(ltd:move(-1))
    end)
  end)

  describe("fraction method", function()
    it("calculates current state of the limited as fraction", function()
      assert.are.equal(0.75, limited(3, 0, 4):fraction())
    end)
  end)
end)