local command = require("neo-tree.command")
local augroup = require("utils").augroup
local map = require("utils").map

local autocmd = vim.api.nvim_create_autocmd

require("neo-tree").setup({
	sources = { "filesystem", "buffers", "git_status", "document_symbols" },
	open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
	filesystem = {
		bind_to_cwd = false,
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
		hijack_netrw_behavior = "open_current",
	},
	window = {
		mappings = {
			["<TAB>"] = {
				"toggle_node",
				nowait = true,
			},
			["<leader>-"] = "open_split",
			["<leade>\\"] = "open_vsplit",
			["a"] = {
				"add",
				config = {
					show_path = "absolute",
				},
			},
			["A"] = {
				"add_directory",
				config = {
					show_path = "absolute",
				},
			},
			["c"] = {
				"copy",
				config = {
					show_path = "absolute",
				},
			},
			["m"] = {
				"move",
				config = {
					show_path = "absolute",
				},
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
	group = augroup,
	pattern = "*lazygit",
	callback = function()
		if package.loaded["neo-tree.sources.git_status"] then
			require("neo-tree.sources.git_status").refresh()
		end
	end,
})

map({
	key = "<leader>e",
	cmd = function()
		command.execute({ toggle = true, dir = vim.loop.cwd() })
	end,
	desc = "Explorer",
}, {
	remap = true,
})

map({
	key = "<leader>ge",
	cmd = function()
		command.execute({ source = "git_status", toggle = true })
	end,
	desc = "Explorer",
})

map({
	key = "<leader>be",
	cmd = function()
		command.execute({ source = "buffers", toggle = true })
	end,
	desc = "Explorer",
})
