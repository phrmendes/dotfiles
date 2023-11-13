local buf = vim.lsp.buf
local diag = vim.diagnostic
local g = vim.g
local lsp = vim.lsp
local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local buf_keymap = vim.api.nvim_buf_set_keymap

local bufremove = require("mini.bufremove")
local dap = require("dap")
local dap_python = require("dap-python")
local dap_ui = require("dapui")
local dial = require("dial.map")
local formatters = require("conform")
local gitsigns = require("gitsigns")
local luasnip = require("luasnip")
local metals = require("metals")
local nabla = require("nabla")
local neogen = require("neogen")
local neotest = require("neotest")
local spectre = require("spectre")
local todos = require("todo-comments")
local utils = require("utils")
local wk = require("which-key")

local telescope = {
	builtin = require("telescope.builtin"),
	extensions = require("telescope").extensions,
}

-- [[ augroups ]] -------------------------------------------------------
local ft_group = augroup("UserFiletypeKeymaps", { clear = true })
local lsp_augroup = augroup("UserLspConfig", { clear = true })

-- [[ unbind keys ]] ----------------------------------------------------
local keys = { "<Space>", "<", ">" }

for _, key in ipairs(keys) do
	map({ "n", "v" }, key, "<Nop>", { noremap = true, silent = true })
end

-- [[ multi cursor ]] ---------------------------------------------------
g.multi_cursor_use_default_mapping = 0
g.VM_mouse_mappings = 1

-- [[ which-key settings ]] ---------------------------------------------
wk.setup({ window = { border = "single", position = "bottom" } })

-- [[ keymaps ]] --------------------------------------------------------
map("n", "k", [[v:count == 0 ? "gk" : "k"]], { expr = true, silent = true, desc = "Word wrap" })
map("n", "j", [[v:count == 0 ? "gj" : "j"]], { expr = true, silent = true, desc = "Word wrap" })

map("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode using" })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

map("n", "+", "<cmd>resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (V)" })
map("n", "-", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (H)" })
map("n", "=", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (H)" })
map("n", "_", "<cmd>resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (V)" })

map({ "i", "s" }, "<C-k>", function()
	if luasnip.choice_active() then
		return luasnip.change_choice(-1)
	end
end, { desc = "Snippets: Previous choice" })

map({ "i", "s" }, "<C-j>", function()
	if luasnip.choice_active() then
		return luasnip.change_choice(1)
	end
end, { desc = "Snippets: Next choice" })

map("n", "<C-a>", dial.inc_normal(), { noremap = true, desc = "Dial: Increment" })
map("n", "<C-x>", dial.dec_normal(), { noremap = true, desc = "Dial: Decrement" })
map("v", "<C-a>", dial.inc_visual(), { noremap = true, desc = "Dial: Increment" })
map("v", "<C-x>", dial.dec_visual(), { noremap = true, desc = "Dial: Decrement" })

map("n", "[[", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "]]", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "[h", gitsigns.prev_hunk, { desc = "Git: Previous hunk" })
map("n", "]h", gitsigns.next_hunk, { desc = "Git: Next hunk" })
map("n", "[t", todos.jump_prev, { desc = "Previous todo comment" })
map("n", "]t", todos.jump_next, { desc = "Next todo comment" })

map("n", "<leader>-", "<C-w>s", { desc = "Split window (H)" })
map("n", "<leader>.", telescope.builtin.commands, { desc = "Commands" })
map("n", "<leader>/", telescope.builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })
map("n", "<leader><space>", telescope.builtin.find_files, { desc = "Find files" })
map("n", "<leader>W", "<cmd>wq<cr>", { desc = "Save and quit" })
map("n", "<leader>\\", "<C-w>v", { desc = "Split window (V)" })
map("n", "<leader>a", neogen.generate, { desc = "Generate annotations", noremap = true, silent = true })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })
map("n", "<leader>h", telescope.builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>p", "<cmd>PasteImg<cr>", { desc = "Paste image" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>s", "<cmd>Copilot panel<cr>", { desc = "Copilot sugestions" })
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>x", "<C-w>q", { desc = "Close window" })
map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })

utils.section("b", "buffers", "<leader>", "n")
map("n", "<leader>bb", telescope.builtin.buffers, { desc = "List buffers" })
map("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
map("n", "<leader>bo", "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all other buffers" })

utils.section("c", "ChatGPT", "<leader>", { "n", "v" })
map({ "n", "v" }, "<leader>ca", "<cmd>ChatGPTRun add_tests<cr>", { desc = "Add tests" })
map({ "n", "v" }, "<leader>cc", "<cmd>ChatGPT<cr>", { desc = "ChatGPT" })
map({ "n", "v" }, "<leader>cd", "<cmd>ChatGPTRun docstring<cr>", { desc = "Docstring" })
map({ "n", "v" }, "<leader>ce", "<cmd>ChatGPTEditWithInstruction<cr>", { desc = "Edit with instruction" })
map({ "n", "v" }, "<leader>cf", "<cmd>ChatGPTRun fix_bugs<cr>", { desc = "Fix bugs" })
map({ "n", "v" }, "<leader>cg", "<cmd>ChatGPTRun grammar_correction<cr>", { desc = "Grammar correction" })
map({ "n", "v" }, "<leader>ck", "<cmd>ChatGPTRun keywords<cr>", { desc = "Keywords" })
map({ "n", "v" }, "<leader>cl", "<cmd>ChatGPTRun code_readability_analysis<cr>", { desc = "Code readability analysis" })
map({ "n", "v" }, "<leader>co", "<cmd>ChatGPTRun optimize_code<cr>", { desc = "Optimize code" })
map({ "n", "v" }, "<leader>cs", "<cmd>ChatGPTRun summarize<cr>", { desc = "Summarize" })
map({ "n", "v" }, "<leader>ct", "<cmd>ChatGPTRun translate<cr>", { desc = "Translate" })
map({ "n", "v" }, "<leader>cx", "<cmd>ChatGPTRun explain_code<cr>", { desc = "Explain code" })

utils.section("d", "debugger", "<leader>", { "n", "v" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dl", dap.run_last, { desc = "Run last" })
map("n", "<leader>dt", dap_ui.toggle, { desc = "See last session result" })

map("n", "<leader>dc", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })

map("n", "<F1>", dap.continue, { desc = "Debugger: continue" })
map("n", "<F2>", dap.step_over, { desc = "Debugger: step over" })
map("n", "<F3>", dap.step_into, { desc = "Debugger: step into" })
map("n", "<F5>", dap.step_out, { desc = "Debugger: step out" })

utils.section("f", "files", "<leader>", { "n", "v" })
map("n", "<leader>fg", telescope.builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
map("n", "<leader>fz", telescope.extensions.zoxide.list, { desc = "Zoxide" })
map("n", "<leader>fs", spectre.toggle, { desc = "Search and replace" })
map({ "n", "v" }, "<leader>ff", formatters.format, { desc = "Format file or range" })

utils.section("g", "git", "<leader>", { "n", "v" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff" })

utils.section("gs", "stage", "<leader>", { "n", "v" })
map("n", "<leader>gsu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
map("n", "<leader>gsb", gitsigns.stage_buffer, { desc = "Stage buffer" })
map("v", "<leader>gsh", function()
	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)

utils.section("gr", "reset", "<leader>", { "n", "v" })
map("n", "<leader>grb", gitsigns.reset_buffer, { desc = "Reset buffer" })
map("v", "<leader>grh", function()
	gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)

utils.section("o", "obsidian", "<leader>", { "n", "v" })
map("n", "<leader>o<space>", "<cmd>ObsidianSearch<cr>", { desc = "Search" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
map("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Diary (today)" })
map("n", "<leader>of", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link under cursor" })
map("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open Obsidian" })
map("n", "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch to another note" })

autocmd("FileType", {
	pattern = { "quarto", "markdown" },
	group = ft_group,
	callback = function()
		map({ "n", "i" }, "<C-b>", telescope.extensions.bibtex.bibtex, { desc = "Insert reference" })
		map("n", "<C-CR>", utils.md_toggle, { desc = "Toggle check" })

		utils.section("m", "markdown", "<leader>", "n")
		map("n", "<leader>me", nabla.popup, { desc = "Equation preview popup" })
		map("n", "<leader>mp", "<Plug>MarkdownPreviewToggle", { desc = "Preview" })

		utils.section("mq", "quarto", "<leader>", "n")
		map("n", "<leader>mqp", "<cmd>QuartoPreview<cr>", { desc = "Preview" })
		map("n", "<leader>mqq", "<cmd>QuartoClosePreview<cr>", { desc = "Stop preview" })

		utils.section("z", "zotero", "<leader>", "n")
		map("n", "<leader>zc", "<Plug>ZCitationCompleteInfo", { desc = "Citation info (complete)" })
		map("n", "<leader>zi", "<Plug>ZCitationInfo", { desc = "Citation info" })
		map("n", "<leader>zo", "<Plug>ZOpenAttachment", { desc = "Open attachment" })
		map("n", "<leader>zv", "<Plug>ZViewDocument", { desc = "View exported document" })
		map("n", "<leader>zy", "<Plug>ZCitationYamlRef", { desc = "Citation info (yaml)" })
	end,
})

autocmd("FileType", {
	pattern = "python",
	group = ft_group,
	callback = function()
		buf_keymap(0, "n", "<C-a>", dial.inc_normal("python"), { noremap = true })
		buf_keymap(0, "n", "<C-x>", dial.dec_normal("python"), { noremap = true })

		utils.section("dp", "python", "<leader>", { "n", "v" })
		map("n", "<leader>dpm", dap_python.test_method, { desc = "Test method" })
		map("n", "<leader>dpc", dap_python.test_class, { desc = "Test class" })
		map("v", "<leader>dps", dap_python.debug_selection, { desc = "Debug selection" })
	end,
})

autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	group = ft_group,
	callback = function()
		utils.section("lS", "scala", "<leader>", "n")
		map("n", "<leader>lSw", metals.hover_worksheet, { desc = "Worksheet" })
	end,
})

autocmd("LspAttach", {
	group = lsp_augroup,
	callback = function()
		map("n", "[d", diag.goto_prev, { desc = "LSP: previous diagnostic message" })
		map("n", "]d", diag.goto_next, { desc = "LSP: next diagnostic message" })

		map("n", "gD", buf.declaration, { desc = "LSP: go to declaration" })
		map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP: references" })
		map("n", "gd", telescope.builtin.lsp_definitions, { desc = "LSP: go to definition" })
		map("n", "gh", buf.hover, { desc = "LSP: show hover" })
		map("n", "gi", telescope.builtin.lsp_implementations, { desc = "LSP: go to implementation" })
		map("n", "gr", buf.rename, { desc = "LSP: rename" })
		map("n", "gs", buf.signature_help, { desc = "LSP: signature help" })
		map({ "n", "v" }, "ga", buf.code_action, { desc = "LSP: code actions" })

		utils.section("l", "LSP", "<leader>", { "n", "v" })
		map("n", "<leader>lD", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
		map("n", "<leader>lS", telescope.builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
		map("n", "<leader>lc", lsp.codelens.run, { desc = "Code lens" })
		map("n", "<leader>ld", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
		map("n", "<leader>ll", "<cmd>TroubleToggle loclist<cr>", { desc = "Location list (Trouble)" })
		map("n", "<leader>lq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix list (Trouble)" })
		map("n", "<leader>ls", telescope.builtin.lsp_document_symbols, { desc = "Document symbols" })
		map("n", "<leader>lt", "<cmd>SymbolsOutline<cr>", { desc = "Symbols outline" })

		utils.section("r", "REPL", "<leader>", "n")
		map("n", "<leader>rR", "<cmd>IronRestart<cr>", { desc = "Restart" })
		map("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "Focus" })
		map("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Hide" })
		map("n", "<leader>rr", "<cmd>IronRepl<cr>", { desc = "Open" })

		utils.section("t", "tests", "<leader>", "n")
		map("n", "<leader>tt", neotest.run.run, { desc = "Run nearest test" })
		map("n", "<leader>ts", neotest.run.stop, { desc = "Stop nearest test" })
		map("n", "<leader>ta", neotest.run.attach, { desc = "Attach nearest test" })

		map("n", "<leader>tT", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run current file" })

		map("n", "<leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test" })
	end,
})
