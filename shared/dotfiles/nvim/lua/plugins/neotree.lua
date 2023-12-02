local command = require("neo-tree.command")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

require("neo-tree").setup({
	sources = { "filesystem", "buffers", "git_status", "document_symbols" },
	open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
	filesystem = {
		bind_to_cwd = false,
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
	},
	window = {
		mappings = {
			["<TAB>"] = {
				"toggle_node",
				nowait = true,
			},
		},
	},
	default_component_configs = {
		indent = {
			with_expanders = true,
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
	},
})

autocmd("TermClose", {
	group = augroup("GitNeoTree", { clear = true }),
	pattern = "*lazygit",
	callback = function()
		if package.loaded["neo-tree.sources.git_status"] then
			require("neo-tree.sources.git_status").refresh()
		end
	end,
})

map("n", "<leader>e", function()
	command.execute({ toggle = true, dir = vim.loop.cwd() })
end, { desc = "Explorer", remap = true })

map("n", "<leader>ge", function()
	command.execute({ source = "git_status", toggle = true })
end, { desc = "Git explorer" })

map("n", "<leader>be", function()
	command.execute({ source = "buffers", toggle = true })
end, { desc = "Buffer explorer" })
