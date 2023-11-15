local ai = require("mini.ai")
local bracketed = require("mini.bracketed")
local bufremove = require("mini.bufremove")
local clue = require("mini.clue")
local comment = require("mini.comment")
local cursorword = require("mini.cursorword")
local fuzzy = require("mini.fuzzy")
local hipatterns = require("mini.hipatterns")
local indentscope = require("mini.indentscope")
local jump2d = require("mini.jump2d")
local move = require("mini.move")
local pairs = require("mini.pairs")
local splitjoin = require("mini.splitjoin")
local starter = require("mini.starter")
local surround = require("mini.surround")
local tabline = require("mini.tabline")
local ts_commentstring = require("ts_context_commentstring.internal")

bracketed.setup()
bufremove.setup()
cursorword.setup()
fuzzy.setup()
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

-- highlight patterns

hipatterns.setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

-- keymap clues
clue.setup({
	triggers = {
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = "'" },
		{ mode = "x", keys = "'" },
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
		{ mode = "c", keys = "<C-r>" },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "i", keys = "<C-x>" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
	},
	clues = {
		clue.gen_clues.builtin_completion(),
		clue.gen_clues.g(),
		clue.gen_clues.marks(),
		clue.gen_clues.registers(),
		clue.gen_clues.windows(),
		clue.gen_clues.z(),
		{ mode = "n", keys = "<Leader>b", desc = "+buffers" },
		{ mode = "n", keys = "<Leader>c", desc = "+chatGPT" },
		{ mode = "n", keys = "<Leader>d", desc = "+debugger" },
		{ mode = "n", keys = "<Leader>f", desc = "+files" },
		{ mode = "n", keys = "<Leader>g", desc = "+git" },
		{ mode = "n", keys = "<Leader>gr", desc = "+reset", postkeys = "<Leader>g" },
		{ mode = "n", keys = "<Leader>gs", desc = "+stage", postkeys = "<Leader>g" },
		{ mode = "n", keys = "<Leader>l", desc = "+lsp" },
		{ mode = "n", keys = "<Leader>o", desc = "+obsidian" },
		{ mode = "n", keys = "<Leader>t", desc = "+tests" },
		{ mode = "n", keys = "<Leader>z", desc = "+zotero" },
		{ mode = "x", keys = "<Leader>c", desc = "+debugger" },
		{ mode = "x", keys = "<Leader>f", desc = "+files" },
	},
})
