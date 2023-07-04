local status_treesitter, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_treesitter then
	return
end

local status_context, context = pcall(require, "treesitter-context")
if not status_context then
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

context.setup()
