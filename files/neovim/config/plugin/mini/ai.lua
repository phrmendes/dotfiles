safely("later", function()
  local ai = require("mini.ai")
  local extra = require("mini.extra")

  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      B = extra.gen_ai_spec.buffer(),
      D = extra.gen_ai_spec.diagnostic(),
      I = extra.gen_ai_spec.indent(),
      L = extra.gen_ai_spec.line(),
      N = extra.gen_ai_spec.number(),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
      u = ai.gen_spec.function_call(),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
    },
  })

  local modes = { "n", "x", "o" }

  vim.keymap.set(modes, "]f", function() ai.move_cursor("left", "a", "f", { search_method = "next" }) end, { desc = "Next function" })
  vim.keymap.set(modes, "[f", function() ai.move_cursor("left", "a", "f", { search_method = "prev" }) end, { desc = "Previous function" })
  vim.keymap.set(modes, "]c", function() ai.move_cursor("left", "a", "c", { search_method = "next" }) end, { desc = "Next class" })
  vim.keymap.set(modes, "[c", function() ai.move_cursor("left", "a", "c", { search_method = "prev" }) end, { desc = "Previous class" })
end)
