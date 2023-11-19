local spectre = require("spectre")
local actions = require("spectre.actions")
local wk = require("which-key")

spectre.setup({
	open_cmd = "noswapfile vnew",
	is_block_ui_break = true,
	mapping = {
		["send_to_qf"] = {
			map = "<localleader>q",
			cmd = actions.send_to_qf,
			desc = "send all items to quickfix",
		},
		["replace_cmd"] = {
			map = "<localleader>c",
			cmd = actions.replace_cmd,
			desc = "input replace command",
		},
		["show_option_menu"] = {
			map = "<localleader>o",
			cmd = spectre.show_options,
			desc = "show options",
		},
		["run_current_replace"] = {
			map = "<localleader>r",
			cmd = actions.run_current_replace,
			desc = "replace current line",
		},
		["run_replace"] = {
			map = "<localleader>R",
			cmd = actions.run_replace,
			desc = "replace all",
		},
		["change_view_mode"] = {
			map = "<localleader>v",
			cmd = spectre.change_view,
			desc = "change result view mode",
		},
		["resume_last_search"] = {
			map = "<localleader>l",
			cmd = spectre.resume_last_search,
			desc = "repeat last search",
		},
	},
})

wk.register({
	name = "files",
	s = { spectre.open_visual, "Search and replace" },
}, { prefix = "<leader>f", mode = "n" })

wk.register({
	name = "files",
	s = { spectre.open_visual, "Search and replace selection" },
}, { prefix = "<leader>f", mode = "x" })
