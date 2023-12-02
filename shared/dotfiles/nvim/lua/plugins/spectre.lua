local spectre = require("spectre")

spectre.setup({
	open_cmd = "noswapfile vnew",
	is_block_ui_break = true,
	mapping = {
		["send_to_qf"] = {
			map = "<C-s><C-q>",
			cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
			desc = "send all items to quickfix",
		},
		["replace_cmd"] = {
			map = "<C-s><C-c>",
			cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
			desc = "input replace command",
		},
		["show_option_menu"] = {
			map = "<C-s><C-?>",
			cmd = "<cmd>lua require('spectre').show_options()<CR>",
			desc = "show options",
		},
		["run_current_replace"] = {
			map = "<C-s><C-r>",
			cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
			desc = "replace current line",
		},
		["run_replace"] = {
			map = "<C-s><C-a>",
			cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
			desc = "replace all",
		},
		["change_view_mode"] = {
			map = "<C-s><C-v>",
			cmd = "<cmd>lua require('spectre').change_view()<CR>",
			desc = "change result view mode",
		},
		["resume_last_search"] = {
			map = "<C-s><C-l>",
			cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
			desc = "repeat last search",
		},
		["select_template"] = {
			map = "<C-s><C-p>",
			cmd = "<cmd>lua require('spectre.actions').select_template()<CR>",
			desc = "pick template",
		},
	},
})

vim.keymap.set("n", "<leader>fs", spectre.toggle, { desc = "Find and replace (Spectre)" })
vim.keymap.set("x", "<leader>fs", spectre.open_visual, { desc = "Find and replace (Spectre)" })
