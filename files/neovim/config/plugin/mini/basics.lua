safely("now", function()
  require("mini.basics").setup({
    options = { basic = true, extra_ui = true },
    mappings = { basic = true, option_toggle_prefix = "\\", windows = false, move_with_alt = true },
    autocommands = { basic = true },
  })
end)
