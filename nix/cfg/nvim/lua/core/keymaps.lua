-- [[ variables ]] ------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local buf = vim.lsp.buf
local diag = vim.diagnostic
local g = vim.g
local lsp = vim.lsp
local map = vim.keymap.set

-- [[ imports ]] --------------------------------------------------------
local bufremove = require("mini.bufremove")
local dap = require("dap")
local dap_ui = require("dapui")
local formatters = require("conform")
local gitsigns = require("gitsigns")
local jump2d = require("mini.jump2d")
local linters = require("lint")
local luasnip = require("luasnip")
local move = require("mini.move")
local neogen = require("neogen")
local splitjoin = require("mini.splitjoin")
local surround = require("mini.surround")
local todos = require("todo-comments")
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
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

-- [[ copilot settings ]] -----------------------------------------------
g.copilot_no_tab_map = true
g.copilot_filetypes = { markdown = false }

local copilot_opts = {
	noremap = true,
	silent = true,
	expr = true,
	replace_keycodes = false,
}

-- [[ keymaps ]] --------------------------------------------------------
-- accept copilot suggestion
map("i", "<C-CR>", [[ copilot#Accept("<CR>") ]], copilot_opts)

-- remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- exit mode pressing 'jk'
map("i", "jk", "<ESC>", { noremap = true, silent = true })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true, silent = true })

-- resize windows
map("n", "+", "<cmd>resize +2<cr>", { noremap = true, silent = true })
map("n", "-", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true })
map("n", "=", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true })
map("n", "_", "<cmd>resize -2<cr>", { noremap = true, silent = true })

-- ";" goes to the direction you were moving
map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- make builtin f, F, t, T also repeatable with ";" and ","
map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

-- buffers
utils.section("b", "buffers", "<leader>", "n")
map("n", "<leader>/", telescope.builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })
map("n", "<S-l>", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "<leader>bb", telescope.builtin.buffers, { desc = "List buffers" })
map("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
map("n", "<leader>bo", "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all other buffers" })
map("n", "<leader>bw", bufremove.wipeout, { desc = "Wipeout" })

-- chatgpt
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

-- DAP
map("n", "<F1>", dap.step_over, { desc = "Debugger: step over" })
map("n", "<F2>", dap.step_into, { desc = "Debugger: step into" })
map("n", "<F3>", dap.step_back, { desc = "Debugger: step back" })
map("n", "<F4>", dap.step_out, { desc = "Debugger: step out" })
map("n", "<F5>", dap.continue, { desc = "Debugger: continue" })

utils.section("d", "debugger", "<leader>", { "n", "v" })
map("v", "<leader>de", dap_ui.eval, { desc = "Evaluate" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", utils.conditional_breakpoint, { desc = "Conditional breakpoint" })
map("n", "<leader>dp", dap.pause, { desc = "Pause" })
map("n", "<leader>dq", dap.close, { desc = "Quit" })
map("n", "<leader>dt", dap_ui.toggle, { desc = "See last session result" })

utils.section("dl", "list", "<leader>", "n")
map("n", "<leader>dlv", telescope.extensions.dap.variables, { desc = "Variables" })
map("n", "<leader>dlb", telescope.extensions.dap.list_breakpoints, { desc = "Breakpoints" })

-- files
utils.section("f", "files", "<leader>", "n")
map("n", "<leader><space>", telescope.builtin.find_files, { desc = "Find files" })
map("n", "<leader>fG", telescope.builtin.git_files, { desc = "Git files" })
map("n", "<leader>fg", telescope.builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })

-- git
map("n", "[h", gitsigns.prev_hunk, { desc = "Previous hunk" })
map("n", "]h", gitsigns.next_hunk, { desc = "Next hunk" })

utils.section("g", "git", "<leader>", { "n", "v" })
map("n", "<leader>gB", telescope.builtin.git_branches, { desc = "Branches" })
map("n", "<leader>gC", "<cmd>Git commit %<cr>", { desc = "Commit (project)" })
map("n", "<leader>gL", "<cmd>Git log<cr>", { desc = "Log (project)" })
map("n", "<leader>gP", "<cmd>Git push<cr>", { desc = "Push" })
map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame" })
map("n", "<leader>gc", "<cmd>Git commit %<cr>", { desc = "Commit (file)" })
map("n", "<leader>gd", "<cmd>Git difftool<cr>", { desc = "Diff tool" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>gl", "<cmd>Git log<cr>", { desc = "Log (file)" })
map("n", "<leader>gm", "<cmd>Git mergetool<cr>", { desc = "Merge tool" })
map("n", "<leader>gp", "<cmd>Git pull<cr>", { desc = "Pull" })
map("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Status" })

utils.section("gb", "buffer", "<leader>", { "n", "v" })
map("n", "<leader>gbd", "<cmd>Gvdiffsplit<cr>", { desc = "Diff buffer" })
map("n", "<leader>gbr", gitsigns.reset_buffer, { desc = "Reset buffer" })
map("n", "<leader>gbs", gitsigns.stage_buffer, { desc = "Stage buffer" })

utils.section("gh", "hunk", "<leader>", { "n", "v" })
map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
map("v", "<leader>ghr", utils.git.reset_hunk, { desc = "Reset hunk" })
map("v", "<leader>ghs", utils.git.stage_hunk, { desc = "Stage hunk" })

-- obsidian
utils.section("o", "obsidian", "<leader>", { "n", "v" })
map("n", "<leader>o<space>", "<cmd>ObsidianSearch<cr>", { desc = "Search" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
map("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Diary (today)" })
map("n", "<leader>of", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link under cursor" })
map("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open note" })
map("n", "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch to another note" })
map("n", "<leader>ot", "<cmd>ObsidianTemplate<cr>", { desc = "Insert template" })
map("v", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = "Create new note and insert link" })
map("v", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "Insert link" })

-- todos
map("n", "]t", todos.jump_next, { desc = "Next todo comment" })
map("n", "[t", todos.jump_prev, { desc = "Previous todo comment" })

-- repl
utils.section("r", "REPL", "<leader>", "n")
map("n", "<leader>rs", "<cmd>IronRepl<cr>", { desc = "Open" })
map("n", "<leader>rr", "<cmd>IronRestart<cr>", { desc = "Restart" })
map("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "Focus" })
map("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Hide" })

-- general keymaps
map("n", "<leader>,", telescope.builtin.symbols, { desc = "Symbols" })
map("n", "<leader>-", "<C-w>s", { desc = "Split window" })
map("n", "<leader>.", telescope.builtin.commands, { desc = "Commands" })
map("n", "<leader>S", "<cmd>Copilot panel<cr>", { desc = "Copilot sugestions" })
map("n", "<leader>Z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })
map("n", "<leader>\\", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>a", neogen.generate, { desc = "Generate annotations", noremap = true, silent = true })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })
map("n", "<leader>h", telescope.builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })
map("n", "<leader>x", "<C-w>q", { desc = "Close window" })
map("n", "<leader>z", telescope.extensions.zoxide.list, { desc = "Zoxide" })

-- markdown/quarto
autocmd("FileType", {
	pattern = { "quarto", "markdown" },
	group = ft_group,
	callback = function()
		map({ "n", "i" }, "<C-b>", telescope.extensions.bibtex.bibtex, { desc = "Insert reference" })
		map("n", "<C-x>", utils.md_toggle, { desc = "Toggle check" })

		utils.section("m", "markdown", "<leader>", "n")
		map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Preview" })

		utils.section("mq", "quarto", "<leader>", "n")
		map("n", "<leader>mqp", "<cmd>QuartoPreview<cr>", { desc = "Preview" })
		map("n", "<leader>mqq", "<cmd>QuartoClosePreview<cr>", { desc = "Stop preview" })
	end,
})

-- lsp
autocmd("LspAttach", {
	group = lsp_augroup,
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		map("n", "[d", diag.goto_prev, { desc = "LSP: previous diagnostic message" })
		map("n", "]d", diag.goto_next, { desc = "LSP: next diagnostic message" })
		map("n", "gD", buf.declaration, { desc = "LSP: go to declaration" })
		map("n", "gR", telescope.builtin.lsp_references, { desc = "LSP: go to references" })
		map("n", "gd", telescope.builtin.lsp_definitions, { desc = "LSP: go to definition" })
		map("n", "gh", buf.hover, { desc = "LSP: show hover" })
		map("n", "gi", telescope.builtin.lsp_implementations, { desc = "LSP: go to implementation" })
		map("n", "gr", buf.rename, { desc = "LSP: rename" })
		map("n", "gs", buf.signature_help, { desc = "LSP: signature help" })
		map({ "n", "v" }, "ga", buf.code_action, { desc = "LSP: code actions" })

		utils.section("l", "LSP", "<leader>", { "n", "v" })
		map("n", "<leader>lc", lsp.codelens.run, { desc = "Run code lens" })
		map("n", "<leader>ld", telescope.builtin.diagnostics, { desc = "Diagnostics" })
		map("n", "<leader>ll", linters.try_lint, { desc = "Trigger linter" })
		map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart" })
		map("n", "<leader>ls", telescope.builtin.lsp_document_symbols, { desc = "Document symbols" })
		map("n", "<leader>lw", telescope.builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
		map({ "n", "v" }, "<leader>lf", formatters.format, { desc = "Format file or range" })
	end,
})

-- snippets
map({ "i", "s" }, "<C-p>", function()
	if luasnip.choice_active() then
		return luasnip.change_choice(-1)
	end
end)

map({ "i", "s" }, "<C-n>", function()
	if luasnip.choice_active() then
		return luasnip.change_choice(1)
	end
end)

-- [[ mini stuff ]] -----------------------------------------------------
-- moving around buffer
jump2d.setup({ mappings = { start_jumping = "<leader>j" } })

-- split and join arguments
splitjoin.setup({ mappings = { toggle = "<leader>t" } })

-- surround text objects
utils.section("s", "surround", "<leader>", { "n", "v" })
surround.setup({
	mappings = {
		add = "<leader>sa", -- add surrounding in normal and visual modes
		delete = "<leader>sd", -- delete surrounding
		find = "<leader>sl", -- find surrounding (to the right)
		find_left = "<leader>sh", -- find surrounding (to the left)
		highlight = "<leader>sH", -- highlight surrounding
		replace = "<leader>sr", -- replace surrounding
		update_n_lines = "<leader>sn", -- update `n_lines`
	},
})

-- move text around
move.setup({
	mappings = {
		-- visual mode
		left = "<",
		right = ">",
		down = "<S-j>",
		up = "<S-k>",
		-- normal mode
		line_left = "<",
		line_right = ">",
		line_down = "<S-j>",
		line_up = "<S-k>",
	},
})
