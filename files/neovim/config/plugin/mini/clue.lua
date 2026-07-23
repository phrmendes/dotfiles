safely("later", function()
  local clue = require("mini.clue")

  clue.setup({
    triggers = {
      { mode = "i", keys = "<c-x>" },
      { mode = "n", keys = "<c-c>" },
      { mode = "n", keys = "<c-w>" },
      { mode = { "i", "c" }, keys = "<c-r>" },
      { mode = { "n", "x" }, keys = "'" },
      { mode = { "n", "x" }, keys = "<leader>" },
      { mode = { "n", "x" }, keys = "<localleader>" },
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = "g" },
      { mode = { "n", "x" }, keys = "z" },
      { mode = { "n", "x" }, keys = '"' },
    },
    clues = {
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.square_brackets(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
      { mode = "n", keys = "<leader><tab>", desc = "+tabs" },
      { mode = "n", keys = "<leader>b", desc = "+buffers" },
      { mode = "n", keys = "<leader>k", desc = "+kulala" },
      { mode = "n", keys = "<leader>n", desc = "+notes" },
      { mode = "n", keys = "<leader>t", desc = "+todotxt" },
      { mode = { "n", "x" }, keys = "<leader>a", desc = "+agent" },
      { mode = { "n", "x" }, keys = "<leader>g", desc = "+git" },
      { mode = { "n", "x" }, keys = "<leader>gp", desc = "+PR" },
    },
    window = { delay = 500, config = { width = "auto", border = vim.g.border } },
  })
end)
