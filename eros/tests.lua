local fnl = require "eros.libraries.girvel.functional"

log.trace(inspect({1, 2, 3} / fnl.filter[[x % 2 == 1]]))
log.trace({1, 2, 3} / fnl.contains(2))

-- local function tests(testlist)
--   for name, test in pairs(testlist) do
--     (test() and log.info or log.error)(name)
--   end
-- end

-- local function same(table1, table2)
--   if not fnl.same(table1, table2) then
--     print("table1:", inspect(table1))
--     print("table2:", inspect(table2))

--     return false
--   end

--   return true
-- end

-- tests({
--   ["same() should check for structural equality"] = function()
--     return fnl.same({1, 2, 3}, fnl.copy({1, 2, 3}))
--       and not fnl.same({1, 2}, {1, [4] = 2})
--   end,
--   ["filter() should filter collection"] = function()
--     return same(fnl.filter({1, 2, 3, 4, 5}, function(x) return x % 2 == 1 end), {1, 3, 5})
--   end,
-- })

-- describe("my own library", {
--   describe("toolkit part", {
--     ["should save calculations"] = function()

--     end
--   })
-- })

-- require 'busted.runner'()

-- describe("my own library", function()
--   describe("toolkit part", function()
--     local tk = require "eros.libraries.girvel.toolkit"

--     describe("cache decorator", function()
--       it("should save calculations", function()
--         local cached_factorial
--         local factorial = {f = function(n)
--           return n > 0 and cached_factorial(n - 1) * n or 1
--         end}
--         cached_factorial = factorial.f

--         local result1 = cached_factorial(8)
--         local original_factorial = spy.on(factorial, "f")
--         local result2 = cached_factorial(8)
--         local _ = cached_factorial(3)

--         assert.are.equal(result1, result2)
--         assert.spy(original_factorial).was_not.called()
--       end)
--     end)
--   end)

--   describe("module part", function()
--     local module = require "eros.libraries.girvel.module"

--     describe("require all function", function()
--       it("should import all modules from directory", function()
--         local parent = module.require_all("eros.test_samples.sample1")

--         assert.is_true(parent.sample1)
--         assert.is_false(parent.sample2)
--       end)

--       it("should be recursive", function()
--         local parent = module.require_all("eros.test_samples.sample2")

--         assert.is_true(parent.child.sample)
--       end)

--       it("should recursively use _representation.lua if possible", function()
--         local parent = module.require_all("eros.test_samples.sample3")

--         assert.are.equal(1, parent.a)
--         assert.are.same({b = 1}, parent.b)
--       end)
--     end)
--   end)

--   describe("functional part", function()
--     local fnl = require "eros.libraries.girvel.functional"
    
--     describe("remove function", function()
--       it("should remove value from table", function()
--         t = {1, 2, 3, 4, 5}
--         fnl.remove(t, 4)
--         assert.are.same(t, {1, 2, 3, 5})
--       end)
--     end)

--     describe("deep copy function", function()
--       it("should copy", function()
--         local test_table = {
--           a = 1,
--           b = 2
--         }

--         assert.are.same(
--           test_table, fnl.copy(test_table)
--         )
--       end)

--       it("should be deep", function()
--         local test_table = {
--           a = 1,
--           b = 2,
--           c = {a = 1}
--         }

--         assert.are.same(test_table, fnl.copy(test_table))
--         assert.are.not_equal(test_table.c, fnl.copy(test_table).c)
--       end)

--       it("should use :copy function if it exists", function()
--         local test_table = {
--           a = 1,
--           b = 2,
--           copy = function(self)
--             return {}
--           end
--         }

--         assert.are.same({}, fnl.copy(test_table))
--       end)

--       it("should save internal references", function()
--         local reference = {
--           a = 1, b = 2, c = 3
--         }

--         local original = {
--           reference1 = reference,
--           reference2 = reference,
--           reference_container = {
--             reference = reference
--           }
--         }

--         local copy = fnl.copy(original)

--         assert.are.equal(copy.reference1, copy.reference2)
--         assert.are.equal(copy.reference1, copy.reference_container.reference)
--       end)
--     end)

--     describe("filter function", function()
--       it("should filter tables into other tables", function()
--         local t = {
--           1, 2, 3, 4, 5
--         }

--         assert.are.same({1, 3, 5}, fnl.filter(t, function(x) return x % 2 == 1 end))
--       end)
--     end)
--   end)

--   describe("decorator module", function()
--     local decorator = require("eros.libraries.girvel.decorator")
--     it("should decorate functions", function()
--       local dummy = decorator:new(function(self, f, a, b) return a + b end)
--       spy.on(dummy, "_function")
--       local f = function() end

--       local result = dummy(1, 2) .. f
--       assert.spy(dummy._function).was_called_with(dummy, f, 1, 2)
--       assert.are.equal(3, result)
--     end)
--   end)
-- end)

-- describe("action aspect", function()
--   local action = require("eros.aspects.action")

--   describe(":new", function()
--     it("should realize eDSL", function()
--       local result = action:new[[die | alive -> dead]](1)
--       assert.are.equal("die", result.name)
--       assert.are.equal("alive", result.starting_state)
--       assert.are.equal("dead", result.ending_state)
--       assert.are.equal(1, result.timeline)
--     end)
--   end)
-- end)