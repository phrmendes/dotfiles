local ai = require("mini.ai")
local bufremove = require("mini.bufremove")
local comment = require("mini.comment")
local indentscope = require("mini.indentscope")
local jump = require("mini.jump")
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
jump.setup()

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
		add = "gsa", -- add surrounding in normal and visual modes
		delete = "gsd", -- delete surrounding
		find = "gsf", -- find surrounding (to the right)
		find_left = "gsF", -- find surrounding (to the left)
		highlight = "gsh", -- highlight surrounding
		replace = "gsr", -- replace surrounding
		update_n_lines = "gsn", -- update `n_lines`
	},
})

-- move text around
move.setup({
	mappings = {
		-- visual mode
		left = "<",
		right = ">",
		down = "<S-j>",
		up = "<S-k>",
		-- normal mode
		line_left = "<",
		line_right = ">",
		line_down = "<S-j>",
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
