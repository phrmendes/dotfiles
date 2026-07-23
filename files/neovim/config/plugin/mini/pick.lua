safely("later", function()
  require("mini.pick").setup({
    mappings = { refine = "<c-r>", refine_marked = "<a-r>", paste = "<c-y>", choose_marked = "<c-q>" },
    window = { config = { border = vim.g.border } },
  })

  vim.ui.select = MiniPick.ui_select

  vim.keymap.set("n", "<c-p>", require("helpers").mini.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Live grep" })
  vim.keymap.set("n", "<leader><leader>", MiniPick.builtin.files, { desc = "Files" })
  vim.keymap.set("n", "<leader>?", MiniPick.builtin.help, { desc = "Help" })
  vim.keymap.set("n", "<leader>p", require("helpers").mini.project, { desc = "Projects" })
end)
