local status, zen = pcall(require, "zen-mode")
if not status then
	return
end

zen.setup({
	plugins = {
		gitsigns = { enabled = true },
		tmux = { enabled = true },
		twilight = { enabled = true },
		wezterm = { enabled = true },
	},
})
