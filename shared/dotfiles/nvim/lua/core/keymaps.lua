local wk = require("which-key")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
local g = vim.g
local group = augroup("WrittingSettings", { clear = true })

-- [[ unbind keys ]] ----------------------------------------------------
local keys = { "<Space>", "<", ">" }

for _, key in ipairs(keys) do
	map({ "n", "x" }, key, "<Nop>", { noremap = true, silent = true })
end

-- [[ multi cursor ]] ---------------------------------------------------
g.multi_cursor_use_default_mapping = 0
g.VM_mouse_mappings = 1

-- [[ keymaps ]] --------------------------------------------------------
map("n", "k", [[v:count == 0 ? "gk" : "k"]], { expr = true, silent = true, desc = "Word wrap" })
map("n", "j", [[v:count == 0 ? "gj" : "j"]], { expr = true, silent = true, desc = "Word wrap" })

map("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode" })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

map("n", "+", "<cmd>resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (V)" })
map("n", "-", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (H)" })
map("n", "=", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (H)" })
map("n", "_", "<cmd>resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (V)" })

wk.register({
	["-"] = { "<C-w>s", "Split window (H)" },
	["W"] = { "<cmd>wq<cr>", "Save and quit" },
	["\\"] = { "<C-w>v", "Split window (V)" },
	Q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
	q = { "<cmd>confirm q<cr>", "Quit" },
	w = { "<cmd>w<cr>", "Save" },
	x = { "<C-w>q", "Close window" },
}, { prefix = "<leader>", mode = "n" })

wk.register({
	name = "buffers",
	q = { "<cmd> w <bar> %bd <bar> e# <bar> bd# <cr><cr>", "Close all unfocused" },
}, { prefix = "<leader>b", mode = "n" })

if vim.fn.has("mac") == 0 then
	autocmd("FileType", {
		pattern = { "markdown", "quarto" },
		group = group,
		callback = function()
			local nabla = require("nabla")

			vim.g.markdown_composer_autostart = 0

			wk.register({
				e = { nabla.popup, "Equation preview" },
			}, { prefix = "<localleader>", mode = "n", buffer = 0 })

			wk.register({
				name = "zotero",
				c = { "<Plug>ZCitationCompleteInfo", "Citation info (complete)" },
				i = { "<Plug>ZCitationInfo", "Citation info" },
				o = { "<Plug>ZOpenAttachment", "Open attachment" },
				v = { "<Plug>ZViewDocument", "View exported document" },
				y = { "<Plug>ZCitationYamlRef", "Citation info (yaml)" },
			}, { prefix = "<leader>z", mode = "n", buffer = 0 })
		end,
	})
end
