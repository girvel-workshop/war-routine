package.path = '?.lua;framework/?.lua;lib/?.lua'
package.cpath = ''

describe("environment library", function()
  local env = require "env"

  describe("push function", function()
    it("pushes upper environment", function()
      local it_works = false

      local f = function()
        env.push()
        it_works = a == 1
      end
      local a = 1
      f()

      assert.is_true(it_works)
    end)
  end)

  describe("append function", function()
    it("makes the env available inside the function", function()
      local it_works = env.append(
        {f = function() return true end},
        function()
          return f()
        end
      )

      assert.is_true(it_works)
    end)

    it("can be nested", function()
      local it_works = env.append({a=1}, function()
        return env.append({result=true}, function()
          return a == 1 and result
        end)
      end)

      assert.is_true(it_works)
    end)
  end)

  describe("use function", function()
    it("isolates environment to the given one", function()
      env.use({a=1, assert=assert}, function()
        assert.is_nil(print)
        assert.are.equal(a, 1)
      end)
    end)
  end)
end)