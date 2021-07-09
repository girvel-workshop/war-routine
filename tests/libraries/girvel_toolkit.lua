require 'busted.runner'()
tk = require "libraries.girvel_toolkit"

describe("my own lua framework", function()
  describe("deep copy function", function()
    it("should copy", function()
      test_table = {
        a = 1,
        b = 2
      }

      assert.are.same(
        test_table, tk.copy(test_table)
      )
    end)
  end)
end)