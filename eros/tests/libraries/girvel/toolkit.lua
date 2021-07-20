require 'busted.runner'()
local tk = require "eros.libraries.girvel.toolkit"
local fnl = require "eros.libraries.girvel.functional"

describe("my own lua framework", function()
  describe("endswith function", function()
    it("should check postfixes", function()
      assert.is_true(("hello world"):endswith("orld"))
      assert.is_false(("hi world"):endswith("dd"))
    end)
  end)

  describe("startswith function", function()
    it("should check prefixes", function()
      assert.is_true(("hello world"):startswith("hello w"))
      assert.is_false(("hi world"):startswith("dd"))
    end)
  end)

  describe("remove function", function()
    it("should remove value from table", function()
      t = {1, 2, 3, 4, 5}
      tk.remove(t, 4)
      assert.are.same(t, {1, 2, 3, 5})
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
      assert.are.not_equal(test_table.c, tk.copy(test_table).c)
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

    it("should save internal references", function()
      local reference = {
        a = 1, b = 2, c = 3
      }

      local original = {
        reference1 = reference,
        reference2 = reference,
        reference_container = {
          reference = reference
        }
      }

      local copy = tk.copy(original)

      assert.are.equal(copy.reference1, copy.reference2)
      assert.are.equal(copy.reference1, copy.reference_container.reference)
    end)
  end)

  describe("filter function", function()
    it("should filter tables into other tables", function()
      local t = {
        1, 2, 3, 4, 5
      }

      assert.are.same({1, 3, 5}, fnl.filter(t, function(x) return x % 2 == 1 end))
    end)
  end)

  describe("require all function", function()
    it("should import all modules from directory", function()
      local parent = tk.require_all("eros.tests.libraries.girvel.sample1")

      assert.is_true(parent.sample1)
      assert.is_false(parent.sample2)
    end)

    it("should be recursive", function()
      local parent = tk.require_all("eros.tests.libraries.girvel.sample2")

      assert.is_true(parent.child.sample)
    end)

    it("should recursively use _representation.lua if possible", function()
      local parent = tk.require_all("eros.tests.libraries.girvel.sample3")

      assert.are.equal(1, parent.a)
      assert.are.same({b = 1}, parent.b)
    end)
  end)
end)

local action = require("eros.aspects.action")

describe("action aspect", function()
  describe(":new", function()
    it("should realize eDSL", function()
      local result = action:new[[die | alive -> dead]](1)
      assert.are.equal("die", result.name)
      assert.are.equal("alive", result.starting_state)
      assert.are.equal("dead", result.ending_state)
      assert.are.equal(1, result.timeline)
    end)
  end)
end)