require 'busted.runner'()
inspect = require "libraries.inspect"
tk = require "libraries.girvel_toolkit"

describe("my own lua framework", function()
  describe("endswith function", function()
    it("should check postfixes", function()
      assert.is_true(tk.endswith("hello world", "orld"))
      assert.is_false(tk.endswith("hi world", "dd"))
    end)
  end)

  describe("startswith function", function()
    it("should check prefixes", function()
      assert.is_true(tk.startswith("hello world", "hello w"))
      assert.is_false(tk.startswith("hi world", "dd"))
    end)
  end)

  describe("deep copy function", function()
    it("should copy", function()
      local test_table = {
        a = 1,
        b = 2
      }

      assert.are.same(
        test_table, tk.copy(test_table)
      )
    end)

    it("should be deep", function()
      local test_table = {
        a = 1,
        b = 2,
        c = {a = 1}
      }

      assert.are.same(test_table, tk.copy(test_table))
    end)

    it("should use :copy function if it exists", function()
      local test_table = {
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
      local parent = tk.require_all("tests.libraries.sample1")

      assert.is_true(parent.sample1)
      assert.is_false(parent.sample2)
    end)

    it("should be recursive", function()
      local parent = tk.require_all("tests.libraries.sample2")

      assert.is_true(parent.child.sample)
    end)

    it("should use _representation.lua if possible", function()
      local parent = tk.require_all("tests.libraries.sample3")

      assert.are.equal("Hello, world!", parent)
      assert.is_nil(parent.a)
    end)
  end)
end)