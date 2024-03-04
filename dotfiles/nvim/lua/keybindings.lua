local augroup = require("utils").augroup
local map = require("utils").keys.map
local section = require("utils").keys.section
local autocmd = vim.api.nvim_create_autocmd
local provider = require("utils").lsp.provider

-- unbind keys -----------------------------------------------------------------
local unbind = { n = { "<", ">", "<Space>" }, v = { "<", ">" } }

for mode, keys in pairs(unbind) do
	for _, key in ipairs(keys) do
		vim.keymap.set(mode, key, "<Nop>", { noremap = true, silent = true })
	end
end

-- exit terminal mode ----------------------------------------------------------
map({ mode = "t", key = "<ESC><ESC>", cmd = "<C-\\><C-n>", desc = "Exit terminal mode" }, {
	noremap = true,
	silent = true,
})

-- macros ----------------------------------------------------------------------
map({ mode = "n", key = "Q", cmd = "@qj", desc = "Replay macro" })
map({ mode = "v", key = "Q", cmd = "<CMD>norm @q<CR>", desc = "Replay macro" })

-- word wrap -------------------------------------------------------------------
map({ key = "k", cmd = [[v:count == 0 ? "gk" : "k"]], desc = "Word wrap" }, { expr = true, silent = true })
map({ key = "j", cmd = [[v:count == 0 ? "gj" : "j"]], desc = "Word wrap" }, { expr = true, silent = true })

-- move in insert mode ---------------------------------------------------------
map({ mode = { "i", "t" }, key = "<A-j>", cmd = "<Down>", desc = "Move down" }, { noremap = false })
map({ mode = { "i", "t" }, key = "<A-k>", cmd = "<Up>", desc = "Move up" }, { noremap = false })
map({ mode = { "i", "t", "c" }, key = "<A-l>", cmd = "<Right>", desc = "Move right" })
map({ mode = { "i", "t", "c" }, key = "<A-h>", cmd = "<Left>", desc = "Move left" })

-- clear highlights ------------------------------------------------------------
map({ key = "<Esc>", cmd = "<CMD>nohlsearch<CR>", desc = "Clear highlights" })

-- better page up/down ---------------------------------------------------------
map({ key = "<C-d>", cmd = "<C-d>zz", desc = "Page down" })
map({ key = "<C-u>", cmd = "<C-u>zz", desc = "Page up" })

-- resize and split windows ----------------------------------------------------
map({ key = "+", cmd = "<CMD>resize +2<CR>", desc = "Increase window (V)" }, { noremap = true, silent = true })
map({ key = "-", cmd = "<CMD>vertical resize -2<CR>", desc = "Decrease window (H)" }, { noremap = true, silent = true })
map({ key = "=", cmd = "<CMD>vertical resize +2<CR>", desc = "Increase window (H)" }, { noremap = true, silent = true })
map({ key = "_", cmd = "<CMD>resize -2<CR>", desc = "Decrease window (V)" }, { noremap = true, silent = true })
map({ key = "<leader>-", cmd = "<CMD>split<CR>", desc = "Split window (H)" })
map({ key = "<leader>\\", cmd = "<CMD>vsplit<CR>", desc = "Split window (V)" })
map({ key = "<leader>x", cmd = "<C-w>q", desc = "Close window" })
map({ key = "<leader>=", cmd = "<C-w>=", desc = "Resize and make windows equal" })

-- tabs ------------------------------------------------------------------------
map({ key = "<TAB>n", cmd = "<CMD>tabnew<CR>", desc = "New tab" })
map({ key = "<TAB>q", cmd = "<CMD>tabonly<CR>", desc = "Close tab" })
map({ key = "[<TAB>", cmd = "<CMD>tabprevious<CR>", desc = "Previous tab" })
map({ key = "]<TAB>", cmd = "<CMD>tabnext<CR>", desc = "Next tab" })

-- save and quit ---------------------------------------------------------------
map({ key = "<leader>W", cmd = "<CMD>wq<CR>", desc = "Save and quit" })
map({ key = "<leader>q", cmd = "<CMD>confirm q<CR>", desc = "Quit" })
map({ key = "<leader>w", cmd = "<CMD>w<CR>", desc = "Save" })

-- help ------------------------------------------------------------------------
map({ key = "<leader>.", cmd = "<CMD>Telescope commands<CR>", desc = "List commands" })
map({ key = "<leader>?", cmd = "<CMD>Telescope help_tags<CR>", desc = "Help" })

-- undo tree -------------------------------------------------------------------
map({ key = "<leader>u", cmd = "<CMD>UndotreeToggle<CR>", desc = "Toggle undo tree" })

-- file explorer ---------------------------------------------------------------
map({
	key = "<leader>e",
	cmd = function()
		if not require("mini.files").close() then
			require("mini.files").open()
		end
	end,
	desc = "Open file explorer",
})

-- buffers ---------------------------------------------------------------------
section({ key = "<leader>b", name = "buffers" })
map({ key = "<leader>bG", cmd = "<CMD>blast<CR>", desc = "Go to last buffer" })
map({ key = "<leader>bb", cmd = "<CMD>Telescope buffers<CR>", desc = "List" })
map({ key = "<leader>bd", cmd = require("mini.bufremove").delete, desc = "Delete" })
map({ key = "<leader>bf", cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in current buffer" })
map({ key = "<leader>bg", cmd = "<CMD>bfirst<CR>", desc = "Go to last buffer" })
map({ key = "<leader>bq", cmd = "<CMD>%bdelete<bar>edit#<bar>bdelete#<CR>", desc = "Close all unfocused" })
map({ key = "<leader>bw", cmd = require("mini.bufremove").wipeout, desc = "Wipeout" })

-- find ------------------------------------------------------------------------
section({ mode = { "n", "v" }, key = "<leader>f", name = "files/find" })
map({ key = "<leader>ff", cmd = "<CMD>Telescope find_files<CR>", desc = "Find" })
map({ key = "<leader>fg", cmd = "<CMD>Telescope live_grep<CR>", desc = "Live grep" })
map({ key = "<leader>fz", cmd = "<CMD>Telescope zoxide list<CR>", desc = "Zoxide" })
map({ key = "<leader>fs", cmd = require("spectre").toggle, desc = "Search and replace" })

-- dap -------------------------------------------------------------------------
map({ key = "<F3>", cmd = require("dap").step_out, desc = "DAP: step out" })
map({ key = "<F4>", cmd = require("dap").step_into, desc = "DAP: step into" })
map({ key = "<F5>", cmd = require("dap").step_back, desc = "DAP: step back" })
map({ key = "<F6>", cmd = require("dap").continue, desc = "DAP: continue" })
map({ key = "<F7>", cmd = require("dap").step_over, desc = "DAP: step over" })
map({ key = "<S-F6>", cmd = require("dap").pause, desc = "DAP: pause" })
map({ key = "<BS>", cmd = require("dap").close, desc = "DAP: quit" })
map({ key = "<leader>t", cmd = require("dap").toggle_breakpoint, desc = "DAP: toggle breakpoint" })
map({ key = "<leader>U", cmd = require("dapui").toggle, desc = "DAP: toggle UI" })

autocmd("FileType", {
	pattern = { "python" },
	group = augroup,
	callback = function()
		map({ key = "<localleader>c", cmd = require("dap-python").test_class, desc = "DAP: test class" })
		map({ key = "<localleader>f", cmd = require("dap-python").test_method, desc = "DAP: test method" })
		map({ mode = "v", key = "<localleader>d", cmd = require("dap-python").debug_selection, desc = "DAP: debug" })
	end,
})

-- git -------------------------------------------------------------------------
section({ mode = { "n", "v" }, key = "<leader>g", name = "git" })
map({ key = "<leader>gd", cmd = require("gitsigns").diffthis, desc = "Diff" })
map({ key = "<leader>gs", cmd = "<CMD>Telescope git_status<CR>", desc = "Diff (repo)" })
map({ key = "<leader>gt", cmd = require("gitsigns").toggle_current_line_blame, desc = "Blame line" })
map({ key = "<leader>gb", cmd = require("gitsigns").stage_buffer, desc = "Stage buffer" })
map({ key = "<leader>gB", cmd = require("gitsigns").reset_buffer, desc = "Reset buffer" })
map({ key = "<leader>gh", cmd = require("gitsigns").stage_hunk, desc = "Stage hunk" })
map({ key = "<leader>gH", cmd = require("gitsigns").reset_hunk, desc = "Reset hunk" })
map({ key = "<leader>gc", cmd = "<CMD>LazyGitFilter<CR>", desc = "Repository" })
map({ key = "<leader>gC", cmd = "<CMD>LazyGitFilterCurrentFile<CR>", desc = "File" })
map({ key = "<leader>gg", cmd = "<CMD>LazyGit<CR>", desc = "LazyGit" })
map({ key = "<leader>gl", cmd = "<CMD>Telescope lazygit<CR>", desc = "List repos" })

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

-- ia --------------------------------------------------------------------------
if vim.fn.has("mac") == 0 then
	section({ mode = { "n", "v" }, key = "<leader>i", name = "IA" })
	map({ key = "<leader>ic", cmd = "<CMD>ChatGPT<CR>", desc = "ChatGPT" })
	map({ mode = { "n", "v" }, key = "<leader>iS", cmd = "<CMD>ChatGPTRun summarize<CR>", desc = "Summarize" })
	map({ mode = { "n", "v" }, key = "<leader>ia", cmd = "<CMD>ChatGPTRun add_tests<CR>", desc = "Add tests" })
	map({ mode = { "n", "v" }, key = "<leader>id", cmd = "<CMD>ChatGPTRun docstring<CR>", desc = "Docstring" })
	map({ mode = { "n", "v" }, key = "<leader>if", cmd = "<CMD>ChatGPTRun fix_bugs<CR>", desc = "Fix bugs" })
	map({ mode = { "n", "v" }, key = "<leader>ik", cmd = "<CMD>ChatGPTRun keywords<CR>", desc = "Keywords" })
	map({ mode = { "n", "v" }, key = "<leader>io", cmd = "<CMD>ChatGPTRun optimize_code<CR>", desc = "Optimize code" })
	map({ mode = { "n", "v" }, key = "<leader>it", cmd = "<CMD>ChatGPTRun translate<CR>", desc = "Translate" })
	map({ mode = { "n", "v" }, key = "<leader>ix", cmd = "<CMD>ChatGPTRun explain_code<CR>", desc = "Explain code" })

	map({
		mode = { "n", "v" },
		key = "<leader>ie",
		cmd = "<CMD>ChatGPTEditWithInstruction<CR>",
		desc = "Edit with instruction",
	})

	map({
		mode = { "n", "v" },
		key = "<leader>ig",
		cmd = "<CMD>ChatGPTRun grammar_correction<CR>",
		desc = "Grammar correction",
	})

	map({
		mode = { "n", "v" },
		key = "<leader>il",
		cmd = "<CMD>ChatGPTRun code_readability_analysis<CR>",
		desc = "Code readability analysis",
	})
end

-- obsidian --------------------------------------------------------------------
if vim.fn.has("mac") == 0 then
	section({ key = "<leader>o", name = "obsidian" })
	map({ key = "<leader>ob", cmd = "<CMD>ObsidianBacklinks<CR>", desc = "Backlinks" })
	map({ key = "<leader>of", cmd = "<CMD>ObsidianFollowLink<CR>", desc = "Follow link under cursor" })
	map({ key = "<leader>oo", cmd = "<CMD>ObsidianOpen<CR>", desc = "Open Obsidian app" })
	map({ key = "<leader>op", cmd = "<CMD>ObsidianPasteImg<CR>", desc = "Paste image" })
	map({ key = "<leader>os", cmd = "<CMD>ObsidianQuickSwitch<CR>", desc = "Quick switch to another note" })
end

-- annotations -----------------------------------------------------------------
map({ key = "<leader>n", cmd = "<CMD>Neogen<CR>", desc = "Generate annotations" })

-- repl ------------------------------------------------------------------------
map({ mode = { "n", "v" }, key = "<C-c><C-c>", cmd = "<Plug>SlimeParagraphSend", desc = "Send to REPL" })
map({ mode = { "n", "v" }, key = "<C-c><C-v>", cmd = "<Plug>SlimeConfig", desc = "Slime config" })

-- todo ------------------------------------------------------------------------
map({ key = "[t", cmd = require("todo-comments").jump_prev, desc = "Previous todo comment" })
map({ key = "]t", cmd = require("todo-comments").jump_next, desc = "Next todo comment" })

-- zen mode --------------------------------------------------------------------
map({ key = "<leader>Z", cmd = "<CMD>ZenMode<CR>", desc = "Zen mode" })

-- writing ---------------------------------------------------------------------
section({ key = "<leader>z", name = "zotero" })
map({ key = "<leader>zi", cmd = "<Plug>ZCitationInfo", desc = "Citation info" })
map({ key = "<leader>zo", cmd = "<Plug>ZOpenAttachment", desc = "Open attachment" })
map({ key = "<leader>zv", cmd = "<Plug>ZViewDocument", desc = "View exported document" })
map({ key = "<leader>zy", cmd = "<Plug>ZCitationYamlRef", desc = "Citation info (yaml)" })

autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	group = augroup,
	callback = function(event)
		map({
			key = "<C-c><C-m>",
			cmd = "<CMD>MdEval<CR>",
			desc = "Md: Run code block",
			buffer = event.buf,
		}, {
			silent = true,
			noremap = true,
		})

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
			key = "<leader>zc",
			cmd = "<Plug>ZCitationCompleteInfo",
			desc = "Citation info (complete)",
		})
	end,
})

-- lsp and dap ----------------------------------------------------------------
autocmd("LspAttach", {
	group = augroup,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- lsp
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
			key = "<leader>d",
			cmd = "<CMD>TroubleToggle document_diagnostics<CR>",
			buffer = event.buf,
			desc = "LSP: document diagnostics",
		})

		provider(client, "codeAction", function()
			map({
				mode = { "n", "v" },
				key = "<leader>a",
				cmd = require("actions-preview").code_actions,
				buffer = event.buf,
				desc = "LSP: code actions",
			})
		end)

		provider(client, "declaration", function()
			map({
				key = "gD",
				cmd = vim.lsp.buf.declaration,
				buffer = event.buf,
				desc = "LSP: go to declaration",
			})
		end)

		provider(client, "definition", function()
			map({
				key = "gd",
				cmd = "<CMD>Telescope lsp_definitions<CR>",
				buffer = event.buf,
				desc = "LSP: go to definition",
			})
		end)

		provider(client, "documentSymbol", function()
			map({
				key = "<leader>s",
				cmd = "<CMD>Telescope lsp_document_symbols<CR>",
				buffer = event.buf,
				desc = "LSP: document symbols",
			})
		end)

		provider(client, "hover", function()
			map({
				key = "<leader>k",
				cmd = vim.lsp.buf.hover,
				buffer = event.buf,
				desc = "LSP: show hover documentation",
			})
		end)

		provider(client, "implementation", function()
			map({
				key = "gi",
				cmd = "<CMD>Telescope lsp_implementations<CR>",
				buffer = event.buf,
				desc = "LSP: go to implementations",
			})
		end)

		provider(client, "signatureHelp", function()
			map({
				key = "<leader>h",
				cmd = require("lsp_signature").toggle_float_win,
				buffer = event.buf,
				desc = "LSP: toggle signature help",
			})
		end)

		provider(client, "rename", function()
			map({
				key = "<leader>r",
				cmd = vim.lsp.buf.rename,
				buffer = event.buf,
				desc = "LSP: rename symbol",
			})
		end)

		provider(client, "references", function()
			map({
				key = "<leader>R",
				cmd = "<CMD>Telescope lsp_references<CR>",
				buffer = event.buf,
				desc = "LSP: show references",
			})
		end)

		provider(client, "typeDefinition", function()
			map({
				key = "gt",
				cmd = "<CMD>Telescope lsp_type_definitions<CR>",
				buffer = event.buf,
				desc = "LSP: go to type definition",
			})
		end)

		provider(client, "workspaceSymbol", function()
			map({
				key = "<leader>S",
				cmd = "<CMD>Telescope lsp_workspace_symbols<CR>",
				buffer = event.buf,
				desc = "LSP: workspace symbols",
			})
		end)

		-- dap
		map({ key = "<F3>", cmd = require("dap").step_out, desc = "DAP: step out" })
		map({ key = "<F4>", cmd = require("dap").step_into, desc = "DAP: step into" })
		map({ key = "<F5>", cmd = require("dap").step_back, desc = "DAP: step back" })
		map({ key = "<F6>", cmd = require("dap").continue, desc = "DAP: continue" })
		map({ key = "<F7>", cmd = require("dap").step_over, desc = "DAP: step over" })
		map({ key = "<S-F6>", cmd = require("dap").pause, desc = "DAP: pause" })
		map({ key = "<BS>", cmd = require("dap").close, desc = "DAP: quit" })
		map({ key = "<leader>t", cmd = require("dap").toggle_breakpoint, desc = "DAP: toggle breakpoint" })
		map({ key = "<leader>U", cmd = require("dapui").toggle, desc = "DAP: toggle UI" })

		autocmd("FileType", {
			pattern = { "python" },
			group = augroup,
			callback = function()
				map({ key = "<localleader>c", cmd = require("dap-python").test_class, desc = "DAP: test class" })
				map({ key = "<localleader>f", cmd = require("dap-python").test_method, desc = "DAP: test method" })
				map({
					mode = "v",
					key = "<localleader>d",
					cmd = require("dap-python").debug_selection,
					desc = "DAP: debug",
				})
			end,
		})
	end,
})
