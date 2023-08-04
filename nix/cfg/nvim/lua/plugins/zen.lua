local status, zen = pcall(require, "zen-mode")
if not status then
  return
end

zen.setup({
  plugins = {
    gitsigns = { enabled = false }, -- disables git signs
    tmux = { enabled = false },   -- disables the tmux statusline
    wezterm = {
      enabled = false,
      font = "+4",
    },
  },
})
