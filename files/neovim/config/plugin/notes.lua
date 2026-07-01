safely("now", function()
  local notes = require("notes")

  notes.setup({
    path = vim.fs.joinpath(vim.env.HOME, "Documents", "notes"),
    picker = "mini",
    journal = { title_format = "%d/%m/%Y" },
    lsp = {
      marksman = { enabled = true },
      ltex_plus = {
        enabled = true,
        languages = { default = "en-US", additionals = { "pt-BR" } },
      },
    },
  })

  vim.keymap.set("n", "<leader>nn", notes.new, { desc = "New" })
  vim.keymap.set("n", "<leader>ns", notes.search, { desc = "Search" })
  vim.keymap.set("n", "<leader>n/", notes.grep, { desc = "Grep" })
  vim.keymap.set("n", "<leader>nj", notes.journal, { desc = "Journal" })
end)
