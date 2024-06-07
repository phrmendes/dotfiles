local pick = require("mini.pick")

pick.setup({
	mappings = {
		choose_marked = "<c-q>",
		mark = "<c-cr>",
	},
	options = {
		use_cache = true,
	},
	window = {
		config = {
			border = "rounded",
		},
	},
})

pick.registry.files = function(local_opts)
	local opts = { source = { cwd = local_opts.cwd } }
	local_opts.cwd = nil
	return pick.builtin.files(local_opts, opts)
end

pick.registry.live_grep = function(local_opts)
	local opts = { source = { cwd = local_opts.cwd } }
	local_opts.cwd = nil
	return pick.builtin.grep_live(local_opts, opts)
end
