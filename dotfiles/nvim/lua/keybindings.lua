local augroup = require("utils").augroup
local map = require("utils").keys.map
local section = require("utils").keys.section
local autocmd = vim.api.nvim_create_autocmd

-- unbind keys -------------------------------------------
local unbind = { n = { "<", ">", "<Space>" }, v = { "<", ">" } }

for mode, keys in pairs(unbind) do
	for _, key in ipairs(keys) do
		vim.keymap.set(mode, key, "<Nop>", { noremap = true, silent = true })
	end
end

-- macros ------------------------------------------------
map({ mode = "n", key = "Q", cmd = "@qj", desc = "Replay macro" })
map({ mode = "v", key = "Q", cmd = "<CMD>norm @q<CR>", desc = "Replay macro" })

-- word wrap ---------------------------------------------
map({ key = "k", cmd = [[v:count == 0 ? "gk" : "k"]], desc = "Word wrap" }, { expr = true, silent = true })
map({ key = "j", cmd = [[v:count == 0 ? "gj" : "j"]], desc = "Word wrap" }, { expr = true, silent = true })

-- clear highlights --------------------------------------
map({ key = "<Esc>", cmd = "<CMD>nohlsearch<CR>", desc = "Clear highlights" })

-- better page up/down -----------------------------------
map({ key = "<C-d>", cmd = "<C-d>zz", desc = "Page down" })
map({ key = "<C-u>", cmd = "<C-u>zz", desc = "Page up" })

-- saner behavior of n and N -----------------------------
map({ key = "n", cmd = [['Nn'[v:searchforward].'zv']], desc = "Next" }, { expr = true })
map({ key = "N", cmd = [['nN'[v:searchforward].'zv']], desc = "Previous" }, { expr = true })

-- windows -----------------------------------------------
map({ key = "<leader>-", cmd = "<CMD>split<CR>", desc = "Split window (H)" })
map({ key = "<leader>\\", cmd = "<CMD>vsplit<CR>", desc = "Split window (V)" })
map({ key = "<leader>x", cmd = "<C-w>q", desc = "Close window" })
map({ key = "<leader>=", cmd = "<C-w>=", desc = "Resize and make windows equal" })
map({ key = "<leader>_", cmd = "<C-w>_", desc = "Maximize (H)" })
map({ key = "<leader>|", cmd = "<C-w>|", desc = "Maximize (V)" })
map({ key = "<leader>O", cmd = "<C-w>o", desc = "Keep only current window" })

-- tabs --------------------------------------------------
section({ key = "<leader><TAB>", name = "tabs" })
map({ key = "<leader><TAB><TAB>", cmd = "<CMD>tab split<CR>", desc = "Open in new tab" })
map({ key = "<leader><TAB>G", cmd = "<CMD>tablast<CR>", desc = "Last" })
map({ key = "<leader><TAB>d", cmd = "<CMD>tabclose<CR>", desc = "Close" })
map({ key = "<leader><TAB>g", cmd = "<CMD>tabfirst<CR>", desc = "First" })
map({ key = "<leader><TAB>k", cmd = "<CMD>tabonly<CR>", desc = "Keep" })
map({ key = "<leader><TAB>n", cmd = "<CMD>tabnew<CR>", desc = "New" })
map({ key = "[<TAB>", cmd = "<CMD>tabprevious<CR>", desc = "Previous tab" })
map({ key = "]<TAB>", cmd = "<CMD>tabnext<CR>", desc = "Next tab" })

-- save and quit -----------------------------------------
map({ key = "<leader>W", cmd = "<CMD>wq<CR>", desc = "Save and quit" })
map({ key = "<leader>q", cmd = "<CMD>confirm q<CR>", desc = "Quit" })
map({ key = "<leader>w", cmd = "<CMD>w<CR>", desc = "Save" })

-- help --------------------------------------------------
map({ key = "<leader>.", cmd = "<CMD>Telescope commands<CR>", desc = "List commands" })
map({ key = "<leader>?", cmd = "<CMD>Telescope help_tags<CR>", desc = "Help" })

-- undo tree ---------------------------------------------
map({ key = "<leader>u", cmd = "<CMD>UndotreeToggle<CR>", desc = "Toggle undo tree" })

-- copilot -----------------------------------------------
map({
	mode = "i",
	key = "<C-a>",
	cmd = [[ copilot#Accept("<CR>") ]],
	desc = "Accept copilot suggestion",
}, {
	noremap = true,
	silent = true,
	expr = true,
	replace_keycodes = false,
})

map({
	mode = "i",
	key = "<C-h>",
	cmd = [[ copilot#Previous() ]],
	desc = "Previous copilot suggestion",
}, {
	noremap = true,
	silent = true,
	expr = true,
	replace_keycodes = false,
})

map({
	mode = "i",
	key = "<C-l>",
	cmd = [[ copilot#Next() ]],
	desc = "Next copilot suggestion",
}, {
	noremap = true,
	silent = true,
	expr = true,
	replace_keycodes = false,
})

-- file explorer -----------------------------------------
map({
	key = "<leader>E",
	cmd = function()
		if not require("mini.files").close() then
			require("mini.files").open(vim.fn.getcwd(), true)
		end
	end,
	desc = "Open file explorer (cwd)",
})

map({
	key = "<leader>e",
	cmd = function()
		if not require("mini.files").close() then
			require("mini.files").open(vim.fn.expand("%:p:h"), true)
		end
	end,
	desc = "Open file explorer (current file)",
})

-- buffers -----------------------------------------------
section({ key = "<leader>b", name = "buffers" })
map({ key = "<leader>bG", cmd = "<CMD>blast<CR>", desc = "Go to last buffer" })
map({ key = "<leader>bb", cmd = "<CMD>Telescope buffers<CR>", desc = "List" })
map({ key = "<leader>bd", cmd = require("mini.bufremove").delete, desc = "Delete" })
map({ key = "<leader>bf", cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in current buffer" })
map({ key = "<leader>bg", cmd = "<CMD>bfirst<CR>", desc = "Go to last buffer" })
map({ key = "<leader>bk", cmd = "<CMD>%bdelete<bar>edit#<bar>bdelete#<CR>", desc = "Keep only this buffer" })
map({ key = "<leader>bw", cmd = require("mini.bufremove").wipeout, desc = "Wipeout" })

-- find --------------------------------------------------
section({ mode = { "n", "v" }, key = "<leader>f", name = "files/find" })
map({ key = "<leader>ff", cmd = "<CMD>Telescope find_files<CR>", desc = "Find" })
map({ key = "<leader>fg", cmd = "<CMD>Telescope live_grep<CR>", desc = "Live grep" })
map({ key = "<leader>fz", cmd = "<CMD>Telescope zoxide list<CR>", desc = "Zoxide" })
map({ key = "<leader>fs", cmd = require("spectre").toggle, desc = "Search and replace" })

-- git ---------------------------------------------------
section({ mode = { "n", "v" }, key = "<leader>g", name = "git" })
map({ key = "<leader>gB", cmd = require("gitsigns").toggle_current_line_blame, desc = "Blame line" })
map({ key = "<leader>gP", cmd = "<CMD>Neogit push<CR>", desc = "Push" })
map({ key = "<leader>gb", cmd = "<CMD>Telescope git_branches<CR>", desc = "Branches" })
map({ key = "<leader>gc", cmd = "<CMD>Neogit commit<CR>", desc = "Commit" })
map({ key = "<leader>gd", cmd = "<CMD>DiffviewOpen<CR>", desc = "Diff" })
map({ key = "<leader>gg", cmd = "<CMD>Neogit<CR>", desc = "Neogit" })
map({ key = "<leader>gp", cmd = "<CMD>Neogit pull<CR>", desc = "Pull" })

map({
	key = "]h",
	desc = "Next hunk",
	cmd = function()
		if vim.wo.diff then
			return "]h"
		end
		vim.schedule(function()
			require("gitsigns").next_hunk()
		end)
		return "<Ignore>"
	end,
}, {
	expr = true,
})

map({
	key = "[h",
	desc = "Previous hunk",
	cmd = function()
		if vim.wo.diff then
			return "[h"
		end
		vim.schedule(function()
			require("gitsigns").prev_hunk()
		end)
		return "<Ignore>"
	end,
}, {
	expr = true,
})

-- obsidian ----------------------------------------------
if vim.fn.has("mac") == 0 then
	section({ key = "<leader>o", name = "obsidian" })
	map({ key = "<leader>ob", cmd = "<CMD>ObsidianBacklinks<CR>", desc = "Backlinks" })
	map({ key = "<leader>of", cmd = "<CMD>ObsidianFollowLink<CR>", desc = "Follow link under cursor" })
	map({ key = "<leader>oo", cmd = "<CMD>ObsidianOpen<CR>", desc = "Open Obsidian app" })
	map({ key = "<leader>op", cmd = "<CMD>ObsidianPasteImg<CR>", desc = "Paste image" })
	map({ key = "<leader>os", cmd = "<CMD>ObsidianQuickSwitch<CR>", desc = "Quick switch to another note" })
end

-- annotations -------------------------------------------
map({ key = "<leader>n", cmd = "<CMD>Neogen<CR>", desc = "Generate annotations" })

-- todo --------------------------------------------------
map({ key = "[t", cmd = require("todo-comments").jump_prev, desc = "Previous todo comment" })
map({ key = "]t", cmd = require("todo-comments").jump_next, desc = "Next todo comment" })

-- zen mode ----------------------------------------------
map({ key = "<leader>z", cmd = "<CMD>ZenMode<CR>", desc = "Zen mode" })

-- writing -----------------------------------------------
autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	group = augroup,
	callback = function(event)
		map({
			key = "<C-c><C-t>",
			cmd = "<CMD>! md-tangle -f %<CR>",
			desc = "Md: Tangle code block",
			buffer = event.buf,
		}, {
			silent = true,
			noremap = true,
		})

		map({
			buffer = event.buf,
			key = "<leader>Z",
			cmd = "<CMD>Telescope zotero<CR>",
			desc = "Add source from Zotero",
		})
	end,
})

-- lsp and dap -------------------------------------------
autocmd("LspAttach", {
	group = augroup,
	callback = function(event)
		-- lsp -------------------------------------------
		map({ key = "<leader>k", cmd = vim.lsp.buf.hover, buffer = event.buf, desc = "LSP: show hover documentation" })
		map({ key = "<leader>r", cmd = vim.lsp.buf.rename, buffer = event.buf, desc = "LSP: rename symbol" })

		map({
			key = "<leader>D",
			cmd = "<CMD>TroubleToggle workspace_diagnostics<CR>",
			buffer = event.buf,
			desc = "LSP: workspace diagnostics",
		})

		map({
			key = "<leader>F",
			cmd = vim.diagnostic.open_float,
			buffer = event.buf,
			desc = "LSP: floating diagnostics",
		})

		map({
			key = "<leader>R",
			cmd = "<CMD>Telescope lsp_references<CR>",
			buffer = event.buf,
			desc = "LSP: show references",
		})

		map({
			key = "<leader>S",
			cmd = "<CMD>Telescope lsp_workspace_symbols<CR>",
			buffer = event.buf,
			desc = "LSP: workspace symbols",
		})

		map({
			key = "<leader>d",
			cmd = "<CMD>TroubleToggle document_diagnostics<CR>",
			buffer = event.buf,
			desc = "LSP: document diagnostics",
		})

		map({
			key = "<leader>h",
			cmd = require("lsp_signature").toggle_float_win,
			buffer = event.buf,
			desc = "LSP: toggle signature help",
		})

		map({
			key = "<leader>s",
			cmd = "<CMD>Telescope lsp_document_symbols<CR>",
			buffer = event.buf,
			desc = "LSP: document symbols",
		})

		map({
			key = "gD",
			cmd = vim.lsp.buf.declaration,
			buffer = event.buf,
			desc = "LSP: go to declaration",
		})

		map({
			key = "gd",
			cmd = "<CMD>Telescope lsp_definitions<CR>",
			buffer = event.buf,
			desc = "LSP: go to definition",
		})

		map({
			key = "gi",
			cmd = "<CMD>Telescope lsp_implementations<CR>",
			buffer = event.buf,
			desc = "LSP: go to implementations",
		})

		map({
			key = "gt",
			cmd = "<CMD>Telescope lsp_type_definitions<CR>",
			buffer = event.buf,
			desc = "LSP: go to type definition",
		})

		map({
			mode = { "n", "v" },
			key = "<leader>a",
			cmd = require("actions-preview").code_actions,
			buffer = event.buf,
			desc = "LSP: code actions",
		})

		-- dap -------------------------------------------
		map({ key = "<F3>", cmd = require("dap").step_out, desc = "DAP: step out" })
		map({ key = "<F4>", cmd = require("dap").step_into, desc = "DAP: step into" })
		map({ key = "<F5>", cmd = require("dap").step_back, desc = "DAP: step back" })
		map({ key = "<F6>", cmd = require("dap").continue, desc = "DAP: continue" })
		map({ key = "<F7>", cmd = require("dap").step_over, desc = "DAP: step over" })
		map({ key = "<S-F6>", cmd = require("dap").pause, desc = "DAP: pause" })
		map({ key = "<BS>", cmd = require("dap").close, desc = "DAP: quit" })

		section({ mode = { "n" }, key = "<leader>t", name = "DAP" })
		map({ key = "<leader>tb", cmd = require("dap").toggle_breakpoint, desc = "Toggle breakpoint" })
		map({ key = "<leader>tu", cmd = require("dapui").toggle, desc = "Toggle UI" })

		map({
			key = "<leader>tc",
			cmd = function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Toggle conditional breakpoint",
		})

		autocmd("FileType", {
			pattern = { "python" },
			group = augroup,
			callback = function()
				map({ key = "<leader>tc", cmd = require("dap-python").test_class, desc = "Test class (python)" })
				map({ key = "<leader>tf", cmd = require("dap-python").test_method, desc = "Test method (python)" })

				map({
					mode = "v",
					key = "<leader>td",
					cmd = require("dap-python").debug_selection,
					desc = "Debug (python)",
				})
			end,
		})
	end,
})

-- smart splits ------------------------------------------
map({ key = "<A-h>", cmd = require("smart-splits").resize_left, desc = "Resize left" })
map({ key = "<A-j>", cmd = require("smart-splits").resize_down, desc = "Resize down" })
map({ key = "<A-k>", cmd = require("smart-splits").resize_up, desc = "Resize up" })
map({ key = "<A-l>", cmd = require("smart-splits").resize_right, desc = "Resize right" })
map({ key = "<C-h>", cmd = require("smart-splits").move_cursor_left, desc = "Move cursor left" })
map({ key = "<C-j>", cmd = require("smart-splits").move_cursor_down, desc = "Move cursor down" })
map({ key = "<C-k>", cmd = require("smart-splits").move_cursor_up, desc = "Move cursor up" })
map({ key = "<C-l>", cmd = require("smart-splits").move_cursor_right, desc = "Move cursor right" })
map({ key = "<localleader>h", cmd = require("smart-splits").swap_buf_left, desc = "Swap buffer left" })
map({ key = "<localleader>j", cmd = require("smart-splits").swap_buf_down, desc = "Swap buffer down" })
map({ key = "<localleader>k", cmd = require("smart-splits").swap_buf_up, desc = "Swap buffer up" })
map({ key = "<localleader>l", cmd = require("smart-splits").swap_buf_right, desc = "Swap buffer right" })

-- luasnip -----------------------------------------------
map({
	mode = "i",
	key = "<TAB>",
	cmd = function()
		return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<TAB>"
	end,
	desc = "(Luasnip) next",
}, {
	expr = true,
	silent = true,
})

map({
	mode = "s",
	key = "<TAB>",
	cmd = function()
		require("luasnip").jump(1)
	end,
	desc = "(Luasnip) next",
})

map({
	mode = { "i", "s" },
	key = "<S-TAB>",
	cmd = function()
		require("luasnip").jump(-1)
	end,
	desc = "(Luasnip) prev",
})

-- slime -------------------------------------------------
map({ mode = { "n", "v" }, key = "<C-c><C-c>", cmd = "<Plug>SlimeParagraphSend", desc = "Send to REPL" })
map({ mode = { "n", "v" }, key = "<C-c><C-s>", cmd = "<Plug>SlimeConfig", desc = "Slime settings" })
