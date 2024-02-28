local map = require("utils").map
local section = require("utils").section

-- unbind keys -----------------------------------------------------------------
local unbind = {
	n = { "<", ">", "<Space>" },
	v = { "<", ">" },
}

for mode, keys in pairs(unbind) do
	for _, key in ipairs(keys) do
		vim.keymap.set(mode, key, "<Nop>", { noremap = true, silent = true })
	end
end

-- copilot ---------------------------------------------------------------------
vim.g.copilot_no_tab_map = true

map({
	mode = "i",
	key = "<C-a>",
	cmd = [[copilot#Accept("<CR>")]],
	desc = "Accept copilot suggestion",
}, {
	expr = true,
	noremap = true,
	replace_keycodes = false,
	silent = true,
})

-- exit terminal mode ----------------------------------------------------------
map({
	mode = "t",
	key = "<ESC><ESC>",
	cmd = "<C-\\><C-n>",
	desc = "Exit terminal mode",
}, {
	noremap = true,
	silent = true,
})

-- macros ----------------------------------------------------------------------
map({
	mode = "n",
	key = "Q",
	cmd = "@qj",
	desc = "Replay macro",
})

map({
	mode = "v",
	key = "Q",
	cmd = "<CMD>norm @q<CR>",
	desc = "Replay macro",
})

-- word wrap -------------------------------------------------------------------
map({
	key = "k",
	cmd = [[v:count == 0 ? "gk" : "k"]],
	desc = "Word wrap",
}, {
	expr = true,
	silent = true,
})

map({
	key = "j",
	cmd = [[v:count == 0 ? "gj" : "j"]],
	desc = "Word wrap",
}, {
	expr = true,
	silent = true,
})

-- move in insert mode ---------------------------------------------------------
map({
	mode = { "i", "t" },
	key = "<A-j>",
	cmd = "<Down>",
	desc = "Move down",
}, {
	noremap = false,
})

map({
	mode = { "i", "t" },
	key = "<A-k>",
	cmd = "<Up>",
	desc = "Move up",
}, {
	noremap = false,
})

map({
	mode = { "i", "t", "c" },
	key = "<A-l>",
	cmd = "<Right>",
	desc = "Move right",
}, {
	noremap = false,
	silent = false,
})

map({
	mode = { "i", "t", "c" },
	key = "<A-h>",
	cmd = "<Left>",
	desc = "Move left",
}, {
	noremap = false,
	silent = false,
})

-- resize and split windows ----------------------------------------------------
map({
	key = "+",
	cmd = "<CMD>resize +2<CR>",
	desc = "Increase window (V)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "-",
	cmd = "<CMD>vertical resize -2<CR>",
	desc = "Decrease window (H)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "=",
	cmd = "<CMD>vertical resize +2<CR>",
	desc = "Increase window (H)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "_",
	cmd = "<CMD>resize -2<CR>",
	desc = "Decrease window (V)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "<leader>-",
	cmd = "<CMD>split<CR>",
	desc = "Split window (H)",
})

map({
	key = "<leader>\\",
	cmd = "<CMD>vsplit<CR>",
	desc = "Split window (V)",
})

map({
	key = "<leader>x",
	cmd = "<C-w>q",
	desc = "Close window",
})

map({
	key = "<leader>=",
	cmd = "<C-w>=",
	desc = "Resize and make windows equal",
})

-- better page up/down ---------------------------------------------------------
map({
	key = "<C-d>",
	cmd = "<C-d>zz",
	desc = "Page down",
})

map({
	key = "<C-u>",
	cmd = "<C-u>zz",
	desc = "Page up",
})

-- tabs ------------------------------------------------------------------------
map({
	key = "[<TAB>",
	cmd = "<CMD>tabprevious<CR>",
	desc = "Previous tab",
})

map({
	key = "]<TAB>",
	cmd = "<CMD>tabnext<CR>",
	desc = "Next tab",
})

map({
	key = "<TAB>q",
	cmd = "<CMD>tabonly<CR>",
	desc = "Close tab",
})

map({
	key = "<TAB>n",
	cmd = "<CMD>tabnew<CR>",
	desc = "New tab",
})

-- save and quit ---------------------------------------------------------------
map({
	key = "<leader>w",
	cmd = "<CMD>w<CR>",
	desc = "Save",
})

map({
	key = "<leader>q",
	cmd = "<CMD>confirm q<CR>",
	desc = "Quit",
})

map({
	key = "<leader>W",
	cmd = "<CMD>wq<CR>",
	desc = "Save and quit",
})

-- buffers ---------------------------------------------------------------------
section({
	key = "<leader>b",
	name = "buffers",
})

map({
	key = "<leader>bG",
	cmd = "<CMD>blast<CR>",
	desc = "Go to last buffer",
})

map({
	key = "<leader>bg",
	cmd = "<CMD>bfirst<CR>",
	desc = "Go to last buffer",
})

map({
	key = "<leader>bq",
	cmd = "<CMD>%bdelete<bar>edit#<bar>bdelete#<CR>",
	desc = "Close all unfocused",
})

-- find ------------------------------------------------------------------------
section({
	mode = { "n", "v" },
	key = "<leader>f",
	name = "files/find",
})

-- undo tree -------------------------------------------------------------------
map({
	key = "<leader>u",
	cmd = "<CMD>UndotreeToggle<CR>",
	desc = "Toggle undo tree",
})
