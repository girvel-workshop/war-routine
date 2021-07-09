require 'busted.runner'()
inspect = require "libraries.inspect"
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

    it("should be deep", function()
      test_table = {
        a = 1,
        b = 2,
        c = {a = 1}
      }

      assert.are.same(test_table, tk.copy(test_table))
    end)

    it("should use :copy function if it exists", function()
      test_table = {
        a = 1,
        b = 2,
        copy = function(self)
          return {}
        end
      }

      assert.are.same({}, tk.copy(test_table))
    end)
  end)

  describe("require all function", function()
    it("should import all modules from directory", function()
      parent = tk.require_all("tests.libraries.sample1")

      assert.is_true(parent.sample1)
      assert.is_false(parent.sample2)
    end)
  end)
end)