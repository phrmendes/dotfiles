safely("now", function()
  require("snacks").setup({
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    lazygit = { configure = false },
    indent = { enabled = true, indent = { char = "▏", hl = "SnacksIndent" }, scope = { enabled = false }, animate = { enabled = false } },
    statuscolumn = { enabled = true, git = { patterns = { "MiniDiffSign" } } },
    image = { enabled = true },
    debug = { enabled = true },
    terminal = { enabled = true },
  })

  vim.api.nvim_set_hl(0, "SnacksIndent", { fg = require("nix").colors.base01 })

  _G.dd = function(...) Snacks.debug.inspect(...) end
  _G.bt = function() Snacks.debug.backtrace() end

  vim.keymap.set({ "n", "t" }, "<c-t>", function() Snacks.terminal.toggle(nil, { count = vim.v.count1 }) end, { desc = "Toggle terminal" })
  vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
  vim.keymap.set("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open in browser" })
end)
