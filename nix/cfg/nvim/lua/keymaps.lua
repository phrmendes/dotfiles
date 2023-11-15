local buf = vim.lsp.buf
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
local neogen = require("neogen")
local neotest = require("neotest")
local spectre = require("spectre")
local utils = require("utils")

local telescope = {
	builtin = require("telescope.builtin"),
	extensions = require("telescope").extensions,
}

-- [[ augroups ]] -------------------------------------------------------
local ft_group = augroup("UserFiletypeKeymaps", { clear = true })

-- [[ unbind keys ]] ----------------------------------------------------
local keys = { "<Space>", "<", ">" }

for _, key in ipairs(keys) do
	map({ "n", "x" }, key, "<Nop>", { noremap = true, silent = true })
end

-- [[ multi cursor ]] ---------------------------------------------------
g.multi_cursor_use_default_mapping = 0
g.VM_mouse_mappings = 1

-- [[ keymaps ]] --------------------------------------------------------
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

map("n", "k", [[v:count == 0 ? "gk" : "k"]], { expr = true, silent = true, desc = "Word wrap" })
map("n", "j", [[v:count == 0 ? "gj" : "j"]], { expr = true, silent = true, desc = "Word wrap" })

map("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode" })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

map("n", "+", "<cmd>resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (V)" })
map("n", "-", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (H)" })
map("n", "=", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (H)" })
map("n", "_", "<cmd>resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (V)" })

map("n", "<C-a>", dial.inc_normal(), { noremap = true, desc = "Dial: Increment" })
map("n", "<C-x>", dial.dec_normal(), { noremap = true, desc = "Dial: Decrement" })
map("x", "<C-a>", dial.inc_visual(), { noremap = true, desc = "Dial: Increment" })
map("x", "<C-x>", dial.dec_visual(), { noremap = true, desc = "Dial: Decrement" })

map("n", "[h", gitsigns.prev_hunk, { desc = "Git: Previous hunk" })
map("n", "]h", gitsigns.next_hunk, { desc = "Git: Next hunk" })

map("n", "<Leader>-", "<C-w>s", { desc = "Split window (H)" })
map("n", "<Leader>.", telescope.builtin.commands, { desc = "ListcCommands" })
map("n", "<Leader>/", telescope.builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })
map("n", "<Leader><space>", telescope.builtin.find_files, { desc = "Find files" })
map("n", "<Leader>W", "<cmd>wq<cr>", { desc = "Save and quit" })
map("n", "<Leader>\\", "<C-w>v", { desc = "Split window (V)" })
map("n", "<Leader>a", neogen.generate, { desc = "Generate annotations", noremap = true, silent = true })
map("n", "<Leader>e", "<cmd>lua MiniFiles.open()<cr>", { desc = "File explorer" })
map("n", "<Leader>h", telescope.builtin.help_tags, { desc = "Help" })
map("n", "<Leader>p", "<cmd>PasteImg<cr>", { desc = "Paste image" })
map("n", "<Leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<Leader>s", "<cmd>Copilot panel<cr>", { desc = "Copilot sugestions" })
map("n", "<Leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })
map("n", "<Leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<Leader>x", "<C-w>q", { desc = "Close window" })
map("n", "<Leader>Z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })

-- buffers
map("n", "<Leader>bb", telescope.builtin.buffers, { desc = "List" })
map("n", "<Leader>bd", bufremove.delete, { desc = "Delete" })
map("n", "<Leader>bo", "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all unfocused" })

-- chatGPT
map({ "n", "x" }, "<Leader>ca", "<cmd>ChatGPTRun add_tests<cr>", { desc = "Add tests" })
map({ "n", "x" }, "<Leader>cc", "<cmd>ChatGPT<cr>", { desc = "ChatGPT" })
map({ "n", "x" }, "<Leader>cd", "<cmd>ChatGPTRun docstring<cr>", { desc = "Docstring" })
map({ "n", "x" }, "<Leader>ce", "<cmd>ChatGPTEditWithInstruction<cr>", { desc = "Edit with instruction" })
map({ "n", "x" }, "<Leader>cf", "<cmd>ChatGPTRun fix_bugs<cr>", { desc = "Fix bugs" })
map({ "n", "x" }, "<Leader>cg", "<cmd>ChatGPTRun grammar_correction<cr>", { desc = "Grammar correction" })
map({ "n", "x" }, "<Leader>ck", "<cmd>ChatGPTRun keywords<cr>", { desc = "Keywords" })
map({ "n", "x" }, "<Leader>cl", "<cmd>ChatGPTRun code_readability_analysis<cr>", { desc = "Code readability analysis" })
map({ "n", "x" }, "<Leader>co", "<cmd>ChatGPTRun optimize_code<cr>", { desc = "Optimize code" })
map({ "n", "x" }, "<Leader>cs", "<cmd>ChatGPTRun summarize<cr>", { desc = "Summarize" })
map({ "n", "x" }, "<Leader>ct", "<cmd>ChatGPTRun translate<cr>", { desc = "Translate" })
map({ "n", "x" }, "<Leader>cx", "<cmd>ChatGPTRun explain_code<cr>", { desc = "Explain code" })

-- debugger
map("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<Leader>dl", dap.run_last, { desc = "Run last" })
map("n", "<Leader>dt", dap_ui.toggle, { desc = "See last session result" })
map("x", "<Leader>dp", dap_python.debug_selection, { desc = "Python: Debug selection" })

map("n", "<Leader>dc", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })

map("n", "<F1>", dap.continue, { desc = "Debugger: continue" })
map("n", "<F2>", dap.step_over, { desc = "Debugger: step over" })
map("n", "<F3>", dap.step_into, { desc = "Debugger: step into" })
map("n", "<F5>", dap.step_out, { desc = "Debugger: step out" })

-- files
map("n", "<Leader>fg", telescope.builtin.live_grep, { desc = "Live grep" })
map("n", "<Leader>fz", telescope.extensions.zoxide.list, { desc = "Zoxide" })
map("n", "<Leader>fs", spectre.toggle, { desc = "Search and replace" })
map({ "n", "x" }, "<Leader>ff", formatters.format, { desc = "Format file or range" })

-- git
map("n", "<Leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<Leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame" })
map("n", "<Leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<Leader>gd", gitsigns.diffthis, { desc = "Diff" })

map("n", "<Leader>gsu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
map("n", "<Leader>gsb", gitsigns.stage_buffer, { desc = "Buffer" })
map("n", "<Leader>grb", gitsigns.reset_buffer, { desc = "Buffer" })

map("x", "<Leader>gsh", function()
	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("x") })
end, { desc = "Hunk" })

map("x", "<Leader>grh", function()
	gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("x") })
end, { desc = "Hunk" })

-- obsidian
map("n", "<Leader>o<space>", "<cmd>ObsidianSearch<cr>", { desc = "Search" })
map("n", "<Leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
map("n", "<Leader>od", "<cmd>ObsidianToday<cr>", { desc = "Diary (today)" })
map("n", "<Leader>of", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link under cursor" })
map("n", "<Leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open Obsidian" })
map("n", "<Leader>os", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch to another note" })

-- lsp
map("n", "gD", buf.declaration, { desc = "LSP: go to declaration" })
map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP: references" })
map("n", "gd", telescope.builtin.lsp_definitions, { desc = "LSP: go to definition" })
map("n", "gh", buf.hover, { desc = "LSP: show hover" })
map("n", "gi", telescope.builtin.lsp_implementations, { desc = "LSP: go to implementation" })
map("n", "gr", buf.rename, { desc = "LSP: rename" })
map("n", "gs", buf.signature_help, { desc = "LSP: signature help" })
map({ "n", "x" }, "ga", buf.code_action, { desc = "LSP: code actions" })

map("n", "<Leader>lD", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
map("n", "<Leader>lc", lsp.codelens.run, { desc = "Code lens" })
map("n", "<Leader>ld", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
map("n", "<Leader>ll", "<cmd>TroubleToggle loclist<cr>", { desc = "Trouble: location list" })
map("n", "<Leader>lm", metals.hover_worksheet, { desc = "Metals: Worksheet" })
map("n", "<Leader>lq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Trouble: quickfix list" })
map("n", "<Leader>ls", telescope.builtin.lsp_document_symbols, { desc = "Document symbols" })
map("n", "<Leader>lw", telescope.builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })

-- tests
map("n", "<Leader>ta", neotest.run.attach, { desc = "Attach nearest test" })
map("n", "<Leader>ts", neotest.run.stop, { desc = "Stop nearest test" })
map("n", "<Leader>tt", neotest.run.run, { desc = "Run nearest test" })

map("n", "<Leader>tT", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run current file" })

map("n", "<Leader>td", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

-- zotero
map("n", "<Leader>zc", "<Plug>ZCitationCompleteInfo", { desc = "Citation info (complete)" })
map("n", "<Leader>zi", "<Plug>ZCitationInfo", { desc = "Citation info" })
map("n", "<Leader>zo", "<Plug>ZOpenAttachment", { desc = "Open attachment" })
map("n", "<Leader>zv", "<Plug>ZViewDocument", { desc = "View exported document" })
map("n", "<Leader>zy", "<Plug>ZCitationYamlRef", { desc = "Citation info (yaml)" })

-- file specific keymaps
autocmd("FileType", {
	pattern = "markdown",
	group = ft_group,
	callback = function()
		map({ "n", "i" }, "<C-b>", telescope.extensions.bibtex.bibtex, { desc = "Insert reference" })
		map("n", "<C-CR>", utils.md_toggle, { desc = "Toggle checkbox" })
	end,
})

autocmd("FileType", {
	pattern = "python",
	group = ft_group,
	callback = function()
		buf_keymap(0, "n", "<C-a>", dial.inc_normal("python"), { noremap = true, desc = "Increment (python)" })
		buf_keymap(0, "n", "<C-x>", dial.dec_normal("python"), { noremap = true, desc = "Decrement (python)" })
	end,
})
