local augend = require("dial.augend")
local config = require("dial.config")
local dial_map = require("dial.map")

local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local buf_keymap = vim.api.nvim_buf_set_keymap
local group = augroup("UserFiletypeKeymaps", { clear = true })

config.augends:register_group({
	default = {
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%d/%m/%Y"],
		augend.constant.alias.bool,
		augend.integer.alias.decimal_int,
		augend.semver.alias.semver,
	},
	python = {
		augend.integer.alias.decimal_int,
		augend.constant.new({
			elements = { "True", "False" },
			word = false,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "and", "or" },
			word = false,
			cyclic = true,
		}),
	},
})

map("n", "<C-a>", function()
	dial_map.manipulate("increment", "normal")
end)

map("n", "<C-x>", function()
	dial_map.manipulate("decrement", "normal")
end)

map("n", "g<C-a>", function()
	dial_map.manipulate("increment", "gnormal")
end)

map("n", "g<C-x>", function()
	dial_map.manipulate("decrement", "gnormal")
end)

map("x", "<C-a>", function()
	dial_map.manipulate("increment", "visual")
end)

map("x", "<C-x>", function()
	dial_map.manipulate("decrement", "visual")
end)

map("x", "g<C-a>", function()
	dial_map.manipulate("increment", "gvisual")
end)

map("x", "g<C-x>", function()
	dial_map.manipulate("decrement", "gvisual")
end)

autocmd("FileType", {
	pattern = "python",
	group = group,
	callback = function()
		buf_keymap(0, "n", "<C-a>", dial_map.inc_normal("python"))
		buf_keymap(0, "n", "<C-x>", dial_map.dec_normal("python"))
	end,
})
