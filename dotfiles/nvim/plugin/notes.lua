safely("now", function()
  local notes = require("notes")

  notes.setup({
    path = vim.fs.joinpath(vim.env.HOME, "Documents", "notes"),
    picker = "mini",
  })

  vim.keymap.set("n", "<leader>ns", notes.search, { desc = "Search" })
  vim.keymap.set("n", "<leader>n/", notes.grep_live, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>nn", notes.new, { desc = "New" })
end)
