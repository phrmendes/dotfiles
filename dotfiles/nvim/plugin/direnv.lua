safely(
  "now",
  function()
    require("direnv").setup({
      keybindings = {
        allow = "<localleader>a",
        deny = "<localleader>D",
        edit = "<localleader>e",
        reload = "<localleader>r",
      },
    })
  end
)
