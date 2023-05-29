local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

treesitter.setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown" },
	},
	indent = { enable = true },
	autotag = { enable = true },
})
