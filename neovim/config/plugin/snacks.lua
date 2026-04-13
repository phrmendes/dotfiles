safely("now", function()
  require("snacks").setup({
    input = { enabled = true },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    lazygit = { configure = false },

    indent = { enabled = true, indent = { char = "▏", hl = "SnacksIndent" }, scope = { char = "▏" }, animate = { enabled = false } },
    statuscolumn = { enabled = true, git = { patterns = { "MiniDiffSign" } } },
    image = { enabled = true },
    debug = { enabled = true },
  })

  vim.api.nvim_set_hl(0, "SnacksIndent", { fg = require("nix").base16.palette.base01 })

  _G.dd = function(...) Snacks.debug.inspect(...) end
  _G.bt = function() Snacks.debug.backtrace() end

  vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
  vim.keymap.set("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open in browser" })
  vim.keymap.set({ "n", "t" }, "<c-\\>", function() Snacks.terminal() end, { desc = "Toggle terminal" })
end)
