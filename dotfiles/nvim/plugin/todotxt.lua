now(
  function()
    require("todotxt").setup({
      todotxt = vim.fs.joinpath(vim.env.HOME, "Documents", "notes", "todo.txt"),
      donetxt = vim.fs.joinpath(vim.env.HOME, "Documents", "notes", "done.txt"),
      create_commands = true,
      ghost_text = { enabled = true },
    })
  end
)

vim.keymap.set("n", "<leader>tn", "<cmd>TodoTxt new<cr>", { desc = "New todo entry" })
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTxt<cr>", { desc = "Toggle todo.txt" })
vim.keymap.set("n", "<leader>td", "<cmd>DoneTxt<cr>", { desc = "Toggle done.txt" })
