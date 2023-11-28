local spectre = require("spectre")
local wk = require("which-key")

spectre.setup({
	open_cmd = "noswapfile vnew",
	is_block_ui_break = true,
	mapping = {
		["send_to_qf"] = {
			map = "<localleader>q",
			cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
			desc = "Spectre: send all items to quickfix",
		},
		["replace_cmd"] = {
			map = "<localleader>c",
			cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
			desc = "Spectre: input replace command",
		},
		["show_option_menu"] = {
			map = "<localleader>?",
			cmd = "<cmd>lua require('spectre').show_options()<CR>",
			desc = "Spectre: show options",
		},
		["run_current_replace"] = {
			map = "<localleader>r",
			cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
			desc = "Spectre: replace current line",
		},
		["run_replace"] = {
			map = "<localleader>a",
			cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
			desc = "Spectre: replace all",
		},
		["change_view_mode"] = {
			map = "<localleader>v",
			cmd = "<cmd>lua require('spectre').change_view()<CR>",
			desc = "Spectre: change result view mode",
		},
		["resume_last_search"] = {
			map = "<localleader>l",
			cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
			desc = "Spectre: repeat last search",
		},
		["select_template"] = {
			map = "<localleader>p",
			cmd = "<cmd>lua require('spectre.actions').select_template()<CR>",
			desc = "Spectre: pick template",
		},
	},
})

wk.register({
	s = { spectre.toggle, "Spectre" },
}, { prefix = "<leader>f", mode = "n" })

wk.register({
	name = "files",
	s = { spectre.open_visual, "Spectre" },
}, { prefix = "<leader>f", mode = "x" })
