safely(
  "later",
  function()
    require("bqf").setup({
      func_map = {
        drop = "o",
        open = "<cr>",
        openc = "<c-cr>",
        split = "<c-s>",
        tabc = "",
        tabdrop = "<c-t>",
      },
    })
  end
)
