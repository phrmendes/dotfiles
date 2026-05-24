safely("later", function()
  local key_path = "/run/agenix/bifrost.txt"
  local ok, lines = pcall(vim.fn.readfile, key_path)

  if not ok or #lines == 0 then
    vim.notify("learning.nvim: could not read bifrost key from " .. key_path, vim.log.levels.WARN)
    return
  end

  require("learning").setup({
    eagerness = 0.25,
    debounce_ms = 250,
    win_config = { border = vim.g.border },
    provider = {
      api_key = vim.trim(lines[1]),
      api_url = "https://bifrost.local.ohlongjohnson.tech/v1/chat/completions",
      model = "vertex/claude-sonnet-4-6@default",
    },
  })

  vim.keymap.set("v", "<leader>e", require("learning").explain, { desc = "Explain selected area" })
end)
