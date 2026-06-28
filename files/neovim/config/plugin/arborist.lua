safely("later", function()
  require("arborist").setup({
    update_cadence = "weekly",
    prefer_wasm = false,
  })
end)
