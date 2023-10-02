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
local luasnip = require("luasnip")
local move = require("mini.move")
local nabla = require("nabla")
local neogen = require("neogen")
local splitjoin = require("mini.splitjoin")
local surround = require("mini.surround")
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

-- [[ leader key ]] -----------------------------------------------------
g.mapleader = " "
g.maplocalleader = ","

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
-- unbind keys
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- leader keys
g.mapleader = " "
g.maplocalleader = ","

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

-- quickfix
utils.section("q", "quickfix", "<localleader>", "n")
map("n", "<localleader>qo", "<cmd>copen<cr>", { desc = "Open" })
map("n", "<localleader>qq", "<cmd>cclose<cr>", { desc = "Close" })

-- buffers
utils.section("b", "buffers", "<leader>", "n")
map("n", "<leader>/", telescope.builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })
map("n", "<S-l>", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "<leader>bb", telescope.builtin.buffers, { desc = "List buffers" })
map("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
map("n", "<leader>bo", "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all other buffers" })
map("n", "<leader>bw", bufremove.wipeout, { desc = "Wipeout" })

-- DAP
map("n", "<F1>", dap.step_over, { desc = "Step over [DAP]" })
map("n", "<F2>", dap.step_into, { desc = "Step into [DAP]" })
map("n", "<F3>", dap.step_back, { desc = "Step back [DAP]" })
map("n", "<F4>", dap.step_out, { desc = "Step out [DAP]" })
map("n", "<F5>", dap.continue, { desc = "Continue [DAP]" })

map("v", "<localleader>e", dap_ui.eval, { desc = "Evaluate [DAP]" })

utils.section("d", "DAP", "<leader>", "n")
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
utils.section("g", "git", "<leader>", { "n", "v" })
map("n", "<leader>gB", telescope.builtin.git_bcommits, { desc = "Commits (buffer)" })
map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
map("n", "<leader>gb", telescope.builtin.git_branches, { desc = "Branches" })
map("n", "<leader>gc", telescope.builtin.git_commits, { desc = "Commits" })
map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>gl", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
map("v", "<leader>gr", utils.git.reset_hunk, { desc = "Reset hunk" })
map("v", "<leader>gs", utils.git.stage_hunk, { desc = "Stage hunk" })
map("n", "[h", gitsigns.prev_hunk, { desc = "Previous hunk" })
map("n", "]h", gitsigns.next_hunk, { desc = "Next hunk" })

-- obsidian
utils.section("o", "obsidian", "<leader>", { "n", "v" })
map("n", "<leader>o<space>", "<cmd>ObsidianSearch<cr>", { desc = "Search" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
map("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Diary (today)" })
map("n", "<leader>of", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link under cursor" })
map("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
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
map("n", "<space>rs", "<cmd>IronRepl<cr>", { desc = "Open" })
map("n", "<space>rr", "<cmd>IronRestart<cr>", { desc = "Restart" })
map("n", "<space>rf", "<cmd>IronFocus<cr>", { desc = "Focus" })
map("n", "<space>rh", "<cmd>IronHide<cr>", { desc = "Hide" })

-- general keymaps
map("n", "<leader>.", telescope.builtin.commands, { desc = "Commands" })
map("n", "<leader>S", "<cmd>Copilot panel<cr>", { desc = "Copilot sugestions" })
map("n", "<leader>a", neogen.generate, { desc = "Generate annotations", noremap = true, silent = true })
map("n", "<leader>c", "<cmd>nohl<cr>", { desc = "Clear highlights" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })
map("n", "<leader>h", telescope.builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>s", "<C-w>s", { desc = "Split window" })
map("n", "<leader>u", telescope.extensions.undo.undo, { desc = "Undo tree" })
map("n", "<leader>v", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>x", "<C-w>q", { desc = "Close window" })
map("n", "<leader>z", telescope.extensions.zoxide.list, { desc = "Zoxide" })
map("n", "<localleader>s", telescope.builtin.symbols, { desc = "Symbols" })
map("n", "<localleader>z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })

-- markdown/quarto
autocmd("FileType", {
	pattern = "markdown",
	group = ft_group,
	callback = function()
		map({ "n", "i" }, "<C-b>", telescope.extensions.bibtex.bibtex, { desc = "Insert reference" })
		map("n", "<localleader>e", nabla.toggle_virt, { desc = "Toggle equation preview" })
		map("n", "<localleader>x", utils.md_toggle, { desc = "Toggle check" })
		map("n", "<localleader>p", "<Plug>MarkdownPreviewToggle", { desc = "Markdown preview" })
	end,
})

-- lsp
autocmd("LspAttach", {
	group = lsp_augroup,
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		map("n", "[d", diag.goto_prev, { desc = "Previous diagnostic message" })
		map("n", "]d", diag.goto_next, { desc = "Next diagnostic message" })
		map("n", "gD", buf.declaration, { desc = "Go to declaration [LSP]" })
		map("n", "gR", telescope.builtin.lsp_references, { desc = "Go to references [LSP]" })
		map("n", "gd", telescope.builtin.lsp_definitions, { desc = "Go to definition [LSP]" })
		map("n", "gh", buf.hover, { desc = "Show hover [LSP]" })
		map("n", "gi", telescope.builtin.lsp_implementations, { desc = "Go to implementation [LSP]" })
		map("n", "gr", buf.rename, { desc = "Rename [LSP]" })
		map("n", "gs", buf.signature_help, { desc = "Signature help [LSP]" })

		utils.section("c", "code action [LSP]", "<localleader>", { "n", "v" })
		map({ "n", "v" }, "<localleader>ca", buf.code_action, { desc = "Show available" })

		utils.section("l", "LSP", "<leader>", "n")
		map("n", "<leader>lc", lsp.codelens.run, { desc = "Run code lens" })
		map("n", "<leader>ld", telescope.builtin.diagnostics, { desc = "Diagnostics" })
		map("n", "<leader>lf", formatters.format, { desc = "Format buffer" })
		map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart" })
		map("n", "<leader>ls", telescope.builtin.lsp_document_symbols, { desc = "Document symbols" })
		map("n", "<leader>lw", telescope.builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
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
jump2d.setup({ mappings = { start_jumping = "<localleader>j" } })

-- split and join arguments
splitjoin.setup({ mappings = { toggle = "<localleader>t" } })

-- surround text objects
utils.section("s", "surround", "<localleader>", { "n", "v" })
surround.setup({
	mappings = {
		add = "<localleader>sa", -- add surrounding in normal and visual modes
		delete = "<localleader>sd", -- delete surrounding
		find = "<localleader>sl", -- find surrounding (to the right)
		find_left = "<localleader>sh", -- find surrounding (to the left)
		highlight = "<localleader>sH", -- highlight surrounding
		replace = "<localleader>sr", -- replace surrounding
		update_n_lines = "<localleader>sn", -- update `n_lines`
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
