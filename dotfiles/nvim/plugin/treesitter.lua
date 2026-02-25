safely("now", function()
  local move = require("nvim-treesitter-textobjects.move")
  local rep = require("nvim-treesitter-textobjects.repeatable_move")

  local modes = { "n", "x", "o" }

  vim.g.no_plugin_maps = true

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if name == "ts" and (kind == "install" or kind == "update") then vim.cmd("TSUpdate") end
    end,
  })

  require("nvim-treesitter").install({
    "astro",
    "bash",
    "bibtex",
    "caddy",
    "css",
    "csv",
    "cuda",
    "diff",
    "dockerfile",
    "dot",
    "eex",
    "elixir",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "hcl",
    "heex",
    "helm",
    "html",
    "htmldjango",
    "http",
    "java",
    "javascript",
    "json",
    "just",
    "latex",
    "lua",
    "luadoc",
    "luap",
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "nginx",
    "nix",
    "python",
    "regex",
    "requirements",
    "sql",
    "ssh_config",
    "templ",
    "terraform",
    "todotxt",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "zsh",
  })

  require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })

  vim.keymap.set(modes, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function" })
  vim.keymap.set(modes, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function" })
  vim.keymap.set(modes, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class" })
  vim.keymap.set(modes, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous class" })
  vim.keymap.set(modes, ";", rep.repeat_last_move_next, { desc = "Repeat last move forward" })
  vim.keymap.set(modes, ",", rep.repeat_last_move_previous, { desc = "Repeat last move backward" })
  vim.keymap.set(modes, "f", rep.builtin_f_expr, { expr = true, desc = "Repeat f move forward" })
  vim.keymap.set(modes, "F", rep.builtin_F_expr, { expr = true, desc = "Repeat F move backward" })
  vim.keymap.set(modes, "t", rep.builtin_t_expr, { expr = true, desc = "Repeat t move forward" })
  vim.keymap.set(modes, "T", rep.builtin_T_expr, { expr = true, desc = "Repeat T move backward" })
end)
