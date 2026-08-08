safely(
  "now",
  function()
    require("mini.indentscope").setup({
      symbol = "▏",
      draw = {
        animation = require("mini.indentscope").gen_animation.none(),
        delay = 0,
      },
      options = { try_as_border = true },
    })
  end
)
