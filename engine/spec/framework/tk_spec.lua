describe("toolkit library", function()
  local tk = require "tk"

  describe("tree object", function()
    it("easily creates new subtables", function()
      local tree = tk.tree()

      tree.a.b.c.d = 1
      assert.are.equal(1, tree.a.b.c.d)
    end)
  end)

  describe("get function", function()
    it("gets tree node by a variadic path", function()
      local tree = tk.tree()

      tree.a.b.c.d = 1
      assert.are.equal(1, tk.get(tree, "a", "b", "c", "d"))
    end)
  end)

  describe("set function", function()
    it("sets tree node by a variadic path", function()
      local tree = tk.tree()

      tk.set(tree, 1, "a", "b", "c", "d")
      assert.are.equal(1, tree.a.b.c.d)
    end)
  end)
end)