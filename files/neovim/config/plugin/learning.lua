safely("later", function()
  local key_path = "/run/agenix/deepseek.txt"
  local ok, key_lines = pcall(vim.fn.readfile, key_path)

  if not ok or #key_lines == 0 then
    vim.notify("learning.nvim: could not read deepseek key from " .. key_path, vim.log.levels.WARN)
    return
  end

  require("learning").setup({
    eagerness = 0.25,
    debounce_ms = 250,
    win_config = { border = vim.g.border },
    provider = {
      api_key = vim.trim(key_lines[1]),
      api_url = "https://api.deepseek.com/chat/completions",
      model = "deepseek-chat",
    },
  })

  vim.keymap.set("v", "<leader>e", require("learning").explain, { desc = "Explain selected area" })
end)
