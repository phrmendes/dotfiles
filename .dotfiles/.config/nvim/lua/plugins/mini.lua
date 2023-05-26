local hicursorword = require("mini.cursorword")
local jump = require("mini.jump")
local jump2d = require("mini.jump2d")
local move = require("mini.move")
local pairs = require("mini.pairs")
local splitjoin = require("mini.splitjoin")
local statusline = require("mini.statusline")
local surround = require("mini.surround")
local tabline = require("mini.tabline")

hicursorword.setup()
jump.setup()
pairs.setup()
statusline.setup()
tabline.setup()

surround.setup({
	mappings = {
		add = "<localleader>sa", -- add surrounding in normal and visual modes
		delete = "<localleader>sd", -- delete surrounding
		find = "<localleader>sf", -- find surrounding (to the right)
		find_left = "<localleader>sf", -- find surrounding (to the left)
		highlight = "<localleader>sh", -- highlight surrounding
		replace = "<localleader>sr", -- replace surrounding
		update_n_lines = "<localleader>sn", -- update `n_lines`
		suffix_last = "l", -- suffix to search with "prev" method
		suffix_next = "n", -- suffix to search with "next" method
	},
})

splitjoin.setup({
	mappings = {
		toggle = "<localleader>S",
	},
})

jump2d.setup({
	mappings = {
		start_jumping = "<localleader>j",
	},
})

move.setup({
	mappings = {
		-- visual mode
		left = "<S-h>",
		right = "<S-l>",
		down = "<S-j>",
		up = "<S-k>",
		-- normal mode
		line_left = "<S-h>",
		line_right = "<S-l>",
		line_down = "<S-j>",
		line_up = "<S-k>",
	},
})
