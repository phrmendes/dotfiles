local ai = require("mini.ai")
local bufremove = require("mini.bufremove")
local comment = require("mini.comment")
local indentscope = require("mini.indentscope")
local jump2d = require("mini.jump2d")
local move = require("mini.move")
local pairs = require("mini.pairs")
local splitjoin = require("mini.splitjoin")
local starter = require("mini.starter")
local surround = require("mini.surround")
local tabline = require("mini.tabline")
local ts_commentstring = require("ts_context_commentstring.internal")

bufremove.setup()
pairs.setup()
starter.setup()
tabline.setup()

-- comment text objects
comment.setup({
	options = {
		custom_commentstring = function()
			return ts_commentstring.calculate_commentstring() or vim.bo.commentstring
		end,
	},
})

-- active indenti guide and indent text objects
indentscope.setup({
	symbol = "│",
	options = { try_as_border = true },
})

-- surround text objects
surround.setup({
	mappings = {
		add = "sa",
		delete = "sd",
		find = "sf",
		find_left = "sF",
		highlight = "sh",
		replace = "sr",
		update_n_lines = "sn",
		suffix_last = "l",
		suffix_next = "n",
	},
})

-- move text around
move.setup({
	mappings = {
		-- visual mode
		down = "<S-j>",
		left = "<S-h>",
		right = "<S-l>",
		up = "<S-k>",
		-- normal mode
		line_down = "<S-j>",
		line_left = "<S-h>",
		line_right = "<S-l>",
		line_up = "<S-k>",
	},
})

-- jump through 2d text objects
jump2d.setup({ mappings = { start_jumping = "<leader>j" } })

-- split and join arguments
splitjoin.setup({ mappings = { toggle = "T" } })

-- enhance text objects
ai.setup({
	n_lines = 500,
	custom_textobjects = {
		o = ai.gen_spec.treesitter({
			a = { "@block.outer", "@conditional.outer", "@loop.outer" },
			i = { "@block.inner", "@conditional.inner", "@loop.inner" },
		}, {}),
		f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
		c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
	},
})
