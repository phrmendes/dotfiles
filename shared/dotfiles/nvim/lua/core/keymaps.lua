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

map("n", "<TAB>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<TAB>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<TAB>n", "<cmd>tabnext<cr>", { desc = "New tab" })
map("n", "<TAB>q", "<cmd> bd <bar> tabclose <bar> startinsert<cr>", { desc = "Close tab" })

map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split window (H)" })
map("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split window (V)" })
map("n", "<leader>W", "<cmd>wq<cr>", { desc = "Save and quit" })
map("n", "<leader>Q", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix" })
map("n", "<leader>l", "<cmd>TroubleToggle loclist<cr>", { desc = "Loclist" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>x", "<C-w>q", { desc = "Close window" })
map("n", "<leader>bq", "<cmd> w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all unfocused" })

if vim.fn.has("mac") == 0 then
	autocmd("FileType", {
		pattern = { "markdown", "quarto" },
		group = group,
		callback = function()
			map("n", "<localleader>m", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview", buffer = true })
			map("n", "<localleader>e", require("nabla").popup, { desc = "Markdown preview", buffer = true })

			require("which-key").register({
				["<leader>z"] = { name = "+zotero" },
			}, { mode = "n", buffer = true })

			map("n", "<leader>zc", "<Plug>ZCitationCompleteInfo", { desc = "Citation info (complete)", buffer = true })
			map("n", "<leader>zi", "<Plug>ZCitationInfo", { desc = "Citation info", buffer = true })
			map("n", "<leader>zo", "<Plug>ZOpenAttachment", { desc = "Open attachment", buffer = true })
			map("n", "<leader>zv", "<Plug>ZViewDocument", { desc = "View exported document", buffer = true })
			map("n", "<leader>zy", "<Plug>ZCitationYamlRef", { desc = "Citation info (yaml)", buffer = true })
		end,
	})
end
