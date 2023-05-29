local setup, neodev = pcall(require, "neodev")
if not setup then
	return
end

neodev.setup({
	library = {
		plugins = { "nvim-dap-ui" },
		types = true,
	},
})
