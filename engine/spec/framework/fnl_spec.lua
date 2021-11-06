describe("functional module", function()
  local fnl = require "fnl"
  describe("filter function", function()
    it("should filter sequence by a given predicate", function()
      assert.are.same(
        {2, 4, 6, 8},
        {1, 2, 3, 4, 5, 6, 7, 8} / fnl.filter(function(ix, it) return it % 2 == 0 end)
      )
    end)
  end)

  describe("map function", function()
    it("maps one sequence to another using the given function", function()
      assert.are.same(
        {1, 4, 9, 16},
        {1, 2, 3, 4} / fnl.map(function(ix, it) return it^2 end)
      )
    end)
  end)

  describe("all function", function()
    it("checks whether all the elements of the sequence are truthy", function()
      assert.is_true({true, true, true} / fnl.all(), "pure booleans")
      assert.is_true({true, "123", "a", {}} / fnl.all(), "non-booleans")
      assert.is_false({false, true, 123} / fnl.all(), "non-booleans")
    end)

    it("can pre-map sequence", function()
      assert.is_true(
        {"123", "2312", "4133412"} / fnl.all(function(ix, it) return #it > 2 end)
      )
      assert.is_false(
        {"12", "123"} / fnl.all(function(ix, it) return #it > 2 end)
      )
    end)
  end)

  describe("any function", function()
    it("checks whether any element of the sequence is truthy", function()
      assert.is_false({false, false, false} / fnl.any(), "pure booleans")
      assert.is_true({false, false, {}} / fnl.any(), "non-booleans")
      assert.is_false({false, false} / fnl.any(), "non-booleans")
    end)

    it("can pre-map sequence", function()
      assert.is_false(
        {"123", "2312", "4133412"} / fnl.any(function(ix, it) return #it <= 2 end)
      )
      assert.is_true(
        {"12", "123"} / fnl.any(function(ix, it) return #it <= 2 end)
      )
    end)
  end)

  describe("separate function", function()
    it("separates the sequence by a given item", function()
      assert.are.same(
        {1, 0, 2, 0, 3, 0, 4},
        {1, 2, 3, 4} / fnl.separate(0)
      )
    end)
  end)

  describe("fold function", function()
    it("folds the sequence by a given function", function()
      assert.are_equal(
        63,
        {1, 2, 4, 8, 16, 32} / fnl.fold(function(a, b) return a + b end)
      )
    end)

    it("folds the sequence by a given metamethod", function()
      function some_object(a)
        return setmetatable({value=a}, {__sub=function(self, other)
          return some_object(self.value - other.value)
        end})
      end

      assert.are_equal(
        1,
        ({some_object(82), some_object(40), some_object(41)}
          / fnl.fold "__sub").value
      )
    end)

    it("folds the sequence by a given operator", function()
      assert.are.equal(
        63,
        {1, 2, 4, 8, 16, 32} / fnl.fold "+"
      )
    end)

    it("concatenates strings", function()
      assert.are_equal("1234", {"1", "2", "3", "4"} / fnl.fold())
    end)
  end)

  describe("slice function", function()
    it("slices the table by ipairs and first, last, step", function()
        assert.are.same(
          {2, 4, 6},
          {1, 2, 3, 4, 5, 6, 7, 8, 9} / fnl.slice(2, 6, 2)
        )
    end)
  end)

  describe("inspect function", function()
    it("inspects a table", function()
        assert.are.equal(require[[inspect]]{1, 2, 3}, {1, 2, 3} / fnl.inspect())
    end)
  end)

  describe("unpack function", function()
    it("should unpack a sequence", function()
      local seq = {1, 2, 3}

      --assert.are.same(seq, {seq / fnl.unpack()})
      assert.are.same(seq, {fnl.unpack.base_function(seq)})
    end)
  end)

  describe("values function", function()
    it("returns values of the table by pairs()", function()
      assert.are.same(
        {1, 2, 3} / fnl.set(),
        {a=1, b=2, c=3} / fnl.values() / fnl.set()
      )
    end)
  end)

  describe("remove function", function()
    it("mutates given table by removing the value", function()
      t = {1, 2, 3}
      fnl.remove_mut(t, 2)
      assert.are.same({1, 3}, t)
    end)
  end)

  describe("extend function", function()
    it("extends one table by anothers", function()
      assert.are.same(
        {a=1, b=2, c=3, d=4},
        {a=1} / fnl.extend({b=2, d=4}, {c=3})
      )
    end)
  end)

  describe("copy function", function()
    it("should copy", function()
      local test_table = {
        a = 1,
        b = 2
      }

      local copy = test_table / fnl.copy()

      assert.are.same(test_table, copy)
      assert.are.not_equal(test_table, copy)
    end)

    it("should be deep", function()
      local test_table = {
        a = 1,
        b = 2,
        c = {a = 1}
      }

      local copy = test_table / fnl.copy()

      assert.are.same(test_table, copy)
      assert.are.not_equal(test_table.c, copy.c)
    end)

    it("should use :copy function if it exists", function()
      local test_table = {
        a = 1,
        b = 2,
        copy = function(self)
          return {}
        end
      }

      assert.are.same({}, test_table / fnl.copy())
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

      local copy = original / fnl.copy()

      assert.are.equal(copy.reference1, copy.reference2)
      assert.are.equal(copy.reference1, copy.reference_container.reference)
    end)
  end)

  describe("contains function", function()
    it("checks by ipairs whether the table contains given value", function()
      assert.is_true({1, 2, 3} / fnl.contains(2))
      assert.is_false({4, 5, "6"} / fnl.contains "5")
    end)
  end)

  describe("set function", function()
    it("transforms sequence to a set", function()
      assert.are.same({a=true, [1]=true}, {"a", 1} / fnl.set())
    end)
  end)

  describe("cache decorator", function()
    it("should cache results", function()
      local call_counter = 0
      local f = fnl.cache() .. function(a, b, c)
        call_counter = call_counter + 1
        return a + b + c
      end

      f(1, 2, 3)
      f(1, 2, 3)

      assert.are.equal(1, call_counter)
    end)
  end)

  describe("static generator", function()
    it("generates clojure f() = ...", function()
      local f = fnl.static(2)

      assert.are.equal(2, f(3))
      assert.are.equal(2, f(2))
      assert.are.equal(2, f(1, 2, 3))
      assert.are.equal(2, f "shit")
    end)
  end)

  describe("future features", function()
    describe("range generator", function()
      it("generates ranges", function()
        local r = fnl.future.range_generator(3, -1, -1)
        assert.are.equal(2, r[2])
        assert.are.equal(0, r[4])
        assert.are.equal(nil, r[6])
      end)
    end)
  end)
end)
