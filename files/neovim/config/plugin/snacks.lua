safely("now", function()
  require("snacks").setup({
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    image = { enabled = true },
    terminal = { enabled = true },
  })

  vim.keymap.set({ "n", "t" }, "<c-t>", function() Snacks.terminal.toggle(nil, { count = vim.v.count1 }) end, { desc = "Toggle terminal" })
  vim.keymap.set("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open in browser" })
end)
