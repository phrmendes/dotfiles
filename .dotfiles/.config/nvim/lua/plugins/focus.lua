local setup, focus = pcall(require, "focus")
if not setup then
	return
end

focus.setup({
	autoresize = false,
})
