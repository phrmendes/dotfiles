safely("now", function()
  require("mini.bracketed").setup({
    comment = { suffix = "k" },
    file = { suffix = "e" },
    diagnostic = { options = { float = false } },
  })
end)
