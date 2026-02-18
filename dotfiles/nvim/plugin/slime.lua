later(function()
  vim.g.slime_target = "tmux"
  vim.g.slime_default_config = { socket_name = "default", relative_pane = "{last}" }
  vim.g.slime_bracketed_paste = 1
  vim.g.slime_no_mappings = true
end)
