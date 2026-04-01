safely("now", function()
  local oc = require("opencode")

  vim.keymap.set({ "n", "x" }, "<leader>oa", function() oc.ask("@this: ", { submit = true }) end, { desc = "Ask" })
  vim.keymap.set({ "n", "x" }, "<leader>ox", oc.select, { desc = "Execute action" })
  vim.keymap.set({ "n", "t" }, "<c-.>", oc.toggle, { desc = "Toggle opencode" })
  vim.keymap.set({ "n", "x" }, "go", function() return oc.operator("@this ") end, { expr = true, desc = "Add range to opencode" })
  vim.keymap.set("n", "goo", function() return oc.operator("@this ") .. "_" end, { expr = true, desc = "Add line to opencode" })
end)
