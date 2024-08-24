local augroups = require("utils").augroups
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
local luasnip = require("luasnip")

local keys = {}

keys.std = {
	disable = function()
		map({ "n", "x" }, "s", "<nop>")
		map({ "c", "i", "t" }, "<c-h>", "<nop>")
		map({ "c", "i", "t" }, "<c-j>", "<nop>")
		map({ "c", "i", "t" }, "<c-k>", "<nop>")
		map({ "c", "i", "t" }, "<c-l>", "<nop>")
	end,
	random = function()
		local opts = { noremap = true }

		opts.desc = "Half page down"
		map("n", "<c-d>", "<c-d>zz", opts)

		opts.desc = "Half page up"
		map("n", "<c-u>", "<c-u>zz", opts)

		opts.desc = "Clear highlights"
		map("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

		opts.desc = "Move in insert mode"
		map({ "c", "i" }, "<c-h>", "<left>", opts)
		map({ "c", "i" }, "<c-l>", "<right>", opts)
	end,
	leader = function()
		local opts = { noremap = true }

		opts.desc = "Split (H)"
		map("n", "<leader>-", "<cmd>split<cr>", opts)

		opts.desc = "Split (V)"
		map("n", "<leader>\\", "<cmd>vsplit<cr>", opts)

		opts.desc = "Command history"
		map("n", "<leader>:", function()
			require("mini.extra").pickers.history({ scope = ":" })
		end, opts)

		opts.desc = "Live grep"
		map("n", "<leader>/", require("mini.pick").builtin.grep_live, opts)

		opts.desc = "Resize and make windows equal"
		map("n", "<leader>=", "<c-w>=", opts)

		opts.desc = "Help"
		map("n", "<leader>?", require("mini.pick").builtin.help, opts)

		opts.desc = "Find"
		map("n", "<leader><leader>", require("mini.pick").builtin.files, opts)

		opts.desc = "Keymaps"
		map("n", "<leader>K", require("mini.extra").pickers.keymaps, opts)

		opts.desc = "Undo tree"
		map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

		opts.desc = "Quit"
		map("n", "<leader>q", "<cmd>q<cr>", opts)

		opts.desc = "Visits"
		map("n", "<leader>v", require("mini.extra").pickers.visit_paths, opts)

		opts.desc = "Write"
		map("n", "<leader>w", "<cmd>w<cr>", opts)

		opts.desc = "Quickfix"
		map("n", "<leader>x", "<cmd>copen<cr>", opts)

		opts.desc = "Zen"
		map("n", "<leader>z", "<cmd>ZenMode<cr>", opts)
	end,
	better_keys = function()
		local opts = { expr = true, noremap = true, silent = true, desc = "Better keys" }

		map("n", "j", [[v:count == 0 ? 'gj' : 'j']], opts)
		map("n", "k", [[v:count == 0 ? 'gk' : 'k']], opts)
		map("n", "N", "'nN'[v:searchforward].'zv'", opts)
		map("o", "N", "'nN'[v:searchforward]", opts)
		map("x", "N", "'nN'[v:searchforward]", opts)
		map("n", "n", "'Nn'[v:searchforward].'zv'", opts)
		map("o", "n", "'Nn'[v:searchforward]", opts)
		map("x", "n", "'Nn'[v:searchforward]", opts)
	end,
	buffers = function()
		local opts = { noremap = true }

		opts.desc = "List"
		map("n", "<leader>bb", require("mini.pick").builtin.buffers, opts)

		opts.desc = "First"
		map("n", "<leader>bg", "<cmd>bfirst<cr>", opts)

		opts.desc = "Last"
		map("n", "<leader>bG", "<cmd>blast<cr>", opts)

		opts.desc = "Keep this"
		map("n", "<leader>bk", "<cmd>wall!<bar>%bdelete<bar>edit#<bar>bdelete#<cr>", opts)

		opts.desc = "Delete"
		map("n", "<leader>bd", require("mini.bufremove").delete, opts)

		opts.desc = "Wipeout"
		map("n", "<leader>bw", require("mini.bufremove").wipeout, opts)
	end,
	curl = function()
		local opts = { noremap = true, silent = true }

		opts.desc = "Open curl"
		map("n", "<leader>co", require("curl").open_curl_tab, opts)

		opts.desc = "Open curl (global)"
		map("n", "<leader>cO", require("curl").open_global_tab, opts)

		opts.desc = "Create or open collection"
		map("n", "<leader>cc", require("curl").create_scoped_collection, opts)

		opts.desc = "Create or open collection (global)"
		map("n", "<leader>cC", require("curl").create_global_collection, opts)

		opts.desc = "Pick collection"
		map("n", "<leader>cp", require("curl").pick_scoped_collection, opts)

		opts.desc = "Pick collection (global)"
		map("n", "<leader>cP", require("curl").pick_global_collection, opts)
	end,
	dial = function()
		local opts = { noremap = true, silent = true, desc = "Dial" }

		map("n", "<c-a>", function()
			require("dial.map").manipulate("increment", "normal")
		end, opts)

		map("n", "<c-x>", function()
			require("dial.map").manipulate("decrement", "normal")
		end, opts)

		map("v", "<c-a>", function()
			require("dial.map").manipulate("increment", "visual")
		end, opts)

		map("v", "<c-x>", function()
			require("dial.map").manipulate("decrement", "visual")
		end, opts)
	end,
	executor = function()
		local opts = { noremap = true }

		opts.desc = "Run"
		map("n", "<leader>rr", require("executor").commands.run, opts)

		opts.desc = "Toggle details"
		map("n", "<leader>rt", require("executor").commands.toggle_detail, opts)
	end,
	explorer = function()
		local opts = { noremap = true }

		opts.desc = "Explorer"
		map("n", "<leader>e", function()
			if not require("mini.files").close() then
				require("mini.files").open(vim.fn.expand("%:p:h"))
			end

			require("mini.files").reveal_cwd()
		end, opts)
	end,
	git = function()
		local opts = { noremap = true }

		opts.desc = "Commit"
		map("n", "<leader>g<space>", "<cmd>Git commit<cr>", opts)

		opts.desc = "Add (file)"
		map("n", "<leader>ga", "<cmd>Git add %<cr>", opts)

		opts.desc = "Add (repo)"
		map("n", "<leader>gA", "<cmd>Git add .<cr>", opts)

		opts.desc = "Branches"
		map("n", "<leader>gb", require("mini.extra").pickers.git_branches, opts)

		opts.desc = "Commits (file)"
		map("n", "<leader>gc", function()
			require("mini.extra").pickers.git_commits({ path = vim.fn.expand("%") })
		end, opts)

		opts.desc = "Commits (repo)"
		map("n", "<leader>gC", require("mini.extra").pickers.git_commits, opts)

		opts.desc = "Diff"
		map("n", "<leader>gd", "<cmd>Git diff %<cr>", opts)

		opts.desc = "LazyGit"
		map("n", "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", opts)

		opts.desc = "History"
		map({ "n", "x" }, "<leader>gh", require("mini.git").show_at_cursor, opts)

		opts.desc = "Hunks"
		map("n", "<leader>gH", require("mini.extra").pickers.git_hunks, opts)

		opts.desc = "Pull"
		map("n", "<leader>gp", "<cmd>Git pull<cr>", opts)

		opts.desc = "Push"
		map("n", "<leader>gP", "<cmd>Git push<cr>", opts)
	end,
	luasnip = function()
		local opts = { noremap = true, silent = true }

		opts.desc = "Next snippet choice"
		map({ "i", "s" }, "<c-j>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end, opts)

		opts.desc = "Previous snippet choice"
		map({ "i", "s" }, "<c-k>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(-1)
			end
		end, opts)
	end,
	macros = function()
		local opts = { noremap = true, expr = true, desc = "Replace macro" }

		map("n", "Q", "@q", opts)
		map("x", "Q", "<cmd>norm @q<cr>", opts)
	end,
	obsidian = function()
		local opts = { noremap = true }

		opts.desc = "Backlinks"
		map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", opts)

		opts.desc = "New note"
		map("n", "<leader>on", "<cmd>ObsidianNew<cr>", opts)

		opts.desc = "Extract to new note"
		map("x", "<leader>oe", "<cmd>ObsidianExtractNote<cr>", opts)

		opts.desc = "Add link"
		map("x", "<leader>oa", "<cmd>ObsidianLink<cr>", opts)

		opts.desc = "Add link to new file"
		map("x", "<leader>on", "<cmd>ObsidianLinkNew<cr>", opts)

		opts.desc = "Search"
		map("n", "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", opts)

		opts.desc = "Paste image"
		map("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", opts)

		opts.desc = "Rename"
		map("n", "<leader>or", "<cmd>ObsidianRename<cr>", opts)

		opts.desc = "Live grep"
		map("n", "<leader>og", "<cmd>ObsidianSearch<cr>", opts)

		opts.desc = "Tags"
		map("n", "<leader>ot", "<cmd>ObsidianTags<cr>", opts)
	end,
	slime = function()
		local opts = { noremap = true }

		opts.desc = "Slime: send to terminal"
		map("n", "<c-c><c-c>", "<Plug>SlimeParagraphSend", opts)
		map("v", "<c-c><c-c>", "<Plug>SlimeRegionSend", opts)

		opts.desc = "Slime: settings"
		map("n", "<c-c><c-s>", "<Plug>SlimeConfig", opts)
	end,
	smart_splits = function()
		local opts = { noremap = true, desc = "Smart splits" }

		map("n", "<a-h>", require("smart-splits").resize_left, opts)
		map("n", "<a-j>", require("smart-splits").resize_down, opts)
		map("n", "<a-k>", require("smart-splits").resize_up, opts)
		map("n", "<a-l>", require("smart-splits").resize_right, opts)
		map("n", "<c-h>", require("smart-splits").move_cursor_left, opts)
		map("n", "<c-j>", require("smart-splits").move_cursor_down, opts)
		map("n", "<c-k>", require("smart-splits").move_cursor_up, opts)
		map("n", "<c-l>", require("smart-splits").move_cursor_right, opts)
	end,
	tabs = function()
		local opts = { noremap = true }

		opts.desc = "Previous tab"
		map("n", "[<tab>", "<cmd>tabprevious<cr>", opts)

		opts.desc = "Next tab"
		map("n", "]<tab>", "<cmd>tabnext<cr>", opts)

		opts.desc = "Last tab"
		map("n", "<leader><tab>G", "<cmd>tablast<cr>", opts)

		opts.desc = "Close tab"
		map("n", "<leader><tab>q", "<cmd>tabclose<cr>", opts)

		opts.desc = "First tab"
		map("n", "<leader><tab>g", "<cmd>tabfirst<cr>", opts)

		opts.desc = "Keep only this tab"
		map("n", "<leader><tab>k", "<cmd>tabonly<cr>", opts)

		opts.desc = "New tab"
		map("n", "<leader><tab>n", "<cmd>tabnew<cr>", opts)

		opts.desc = "Edit in tab"
		map("n", "<leader><tab>e", "<cmd>tabedit %<cr>", opts)
	end,
	yanky = function()
		local opts = { noremap = true, desc = "Yanky" }

		map({ "n", "x" }, "y", "<Plug>(YankyYank)", opts)
		map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", opts)
		map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", opts)
		map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", opts)
		map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", opts)
		map("n", "[y", "<Plug>(YankyPreviousEntry)", opts)
		map("n", "y]", "<Plug>(YankyNextEntry)", opts)

		opts.desc = "Yank history"
		map("n", "<leader>y", "<cmd>YankyRingHistory<cr>", opts)
	end,
}

keys.lsp = function(event)
	local opts = { noremap = true, buffer = event.buf }
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	if client then
		if client.supports_method("textDocument/rename") then
			opts.desc = "Rename symbol"
			map("n", "<f2>", vim.lsp.buf.rename, opts)
		end

		if client.supports_method("textDocument/definition") then
			opts.desc = " Go to definition"
			map("n", "gd", function()
				require("mini.extra").pickers.lsp({ scope = "definition" })
			end, opts)
		end

		if client.supports_method("textDocument/declaration") then
			opts.desc = " Go to declaration"
			map("n", "gD", function()
				require("mini.extra").pickers.lsp({ scope = "declaration" })
			end, opts)
		end

		if client.supports_method("textDocument/implementation") then
			opts.desc = " Go to implementation"
			map("n", "gi", function()
				require("mini.extra").pickers.lsp({ scope = "implementation" })
			end, opts)
		end

		if client.supports_method("textDocument/references") then
			opts.desc = " Go to references"
			map("n", "gr", function()
				require("mini.extra").pickers.lsp({ scope = "references" })
			end, opts)
		end

		if client.supports_method("textDocument/typeDefinition") then
			opts.desc = " Go to type definition"
			map("n", "gt", function()
				require("mini.extra").pickers.lsp({ scope = "type_definition" })
			end, opts)
		end

		if client.supports_method("textDocument/codeAction") then
			opts.desc = " Code actions"
			map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, opts)
		end

		if client.supports_method("textDocument/publishDiagnostics") then
			opts.desc = " Diagnostics"
			map("n", "<leader>d", require("mini.extra").pickers.diagnostic, opts)
		end

		if client.supports_method("textDocument/signatureHelp") then
			opts.desc = " Signature help"
			map("n", "<leader>h", vim.lsp.buf.signature_help, opts)
		end

		if client.supports_method("textDocument/inlayHint") then
			opts.desc = " Toggle inlay hints"
			map("n", "<leader>t", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, opts)
		end

		if client.supports_method("textDocument/hover") then
			opts.desc = " Hover"
			map("n", "<leader>k", vim.lsp.buf.hover, opts)
		end

		if client.supports_method("textDocument/documentSymbol") then
			opts.desc = " Symbols (document)"
			map("n", "<leader>s", function()
				require("mini.extra").pickers.lsp({ scope = "document_symbol" })
			end, opts)
		end

		if client.supports_method("workspace/symbol") then
			opts.desc = " Symbols (workspace)"
			map("n", "<leader>S", function()
				require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
			end, opts)
		end
	end
end

keys.dap = function(event)
	local opts = { noremap = true, buffer = event.buf }

	opts.desc = "Step out"
	map("n", "<f3>", require("dap").step_out, opts)

	opts.desc = "Step into"
	map("n", "<f4>", require("dap").step_into, opts)

	opts.desc = "Step back"
	map("n", "<f5>", require("dap").step_back, opts)

	opts.desc = "Continue"
	map("n", "<f6>", require("dap").continue, opts)

	opts.desc = "Step over"
	map("n", "<f7>", require("dap").step_over, opts)

	opts.desc = "Pause"
	map("n", "<s-f6>", require("dap").pause, opts)

	opts.desc = "Terminate"
	map("n", "<del>", require("dap").terminate, opts)

	opts.desc = " Breakpoint"
	map("n", "<localleader>b", require("dap").toggle_breakpoint, opts)

	opts.desc = " Debug last"
	map("n", "<localleader><bs>", require("dap").run_last, opts)

	opts.desc = " Clear all breakpoints"
	map("n", "<localleader><del>", require("dap").clear_breakpoints, opts)

	opts.desc = " Show hover"
	map("n", "<localleader>k", require("dap.ui.widgets").hover, opts)

	opts.desc = " Toggle UI"
	map("n", "<localleader>u", require("dapui").toggle, opts)

	opts.desc = " Eval"
	map("n", "<localleader><cr>", require("dapui").eval, opts)

	opts.desc = " Conditional breakpoint"
	map("n", "<localleader>B", function()
		require("dap").set_breakpoint(vim.fn.input("Condition: "))
	end, opts)
end

keys.neogen = function(event)
	local opts = { noremap = true, buffer = event.buf }

	opts.desc = "Generate documentation"
	map("n", "<leader>G", require("neogen").generate, opts)
end

keys.refactoring = function(event)
	local opts = { noremap = true, buffer = event.buf }

	opts.desc = "Refactoring"
	map({ "n", "x" }, "<leader>r", require("refactoring").select_refactor, opts)

	opts.desc = "Print variable"
	map("n", "<leader>p", require("refactoring").debug.print_var, opts)

	opts.desc = "Clean print statements"
	map("n", "<leader>c", require("refactoring").debug.cleanup, opts)
end

keys.writing = function(event)
	local opts = { noremap = true, buffer = event.buf }

	opts.desc = "Preview equation"
	map("n", "<localleader>e", require("nabla").popup, opts)

	opts.desc = "Add item below"
	map({ "n", "i" }, "<c-cr>", "<cmd>MDListItemBelow<cr>", opts)

	opts.desc = "Add item above"
	map({ "n", "i" }, "<s-cr>", "<cmd>MDListItemAbove<cr>", opts)
end

keys.ft = {
	markdown = function(event)
		local opts = { noremap = true, buffer = event.buf }

		keys.writing(event)

		opts.desc = " Preview"
		map("n", "<leader>p", "<cmd>MarkdownPreviewToggle<cr>", opts)

		opts.desc = "Citation info"
		map("n", "<c-i>", "<Plug>ZCitationInfo", opts)

		opts.desc = "Citation info (complete)"
		map("n", "<c-s-i>", "<Plug>ZCitationCompleteInfo", opts)

		opts.desc = "Open attachment"
		map("n", "<c-o>", "<Plug>ZOpenAttachment", opts)

		opts.desc = "View document"
		map("n", "<c-s-o>", "<Plug>ZViewDocument", opts)

		opts.desc = "YAML reference"
		map("n", "<c-y>", "<Plug>ZCitationYamlRef", opts)
	end,
	python = function(event)
		keys.dap(event)
		keys.neogen(event)
		keys.refactoring(event)

		local opts = { noremap = true, buffer = event.buf }

		opts.desc = " Debug function/method"
		map("n", "<localleader>f", require("dap-python").test_method, opts)

		opts.desc = " Debug class"
		map("n", "<localleader>c", require("dap-python").test_class, opts)

		opts.desc = " Debug selection"
		map("x", "<localleader>s", require("dap-python").debug_selection, opts)
	end,
	scala = function(event)
		keys.dap(event)
		keys.neogen(event)
		keys.refactoring(event)
	end,
	quarto = function(event)
		keys.writing(event)
	end,
}

for _, func in pairs(keys.std) do
	func()
end

autocmd("LspAttach", {
	group = augroups.lsp.attach,
	callback = keys.lsp,
})

for ft, func in pairs(keys.ft) do
	autocmd("FileType", {
		group = augroups.filetype,
		pattern = ft,
		callback = func,
	})
end
