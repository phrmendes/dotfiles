-- [[ variables ]] ------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local g = vim.g
local map = vim.keymap.set

-- [[ imports ]] --------------------------------------------------------
local bufremove = require("mini.bufremove")
local dap = require("dap")
local dap_ui = require("dapui")
local formatters = require("conform")
local gitsigns = require("gitsigns")
local jump2d = require("mini.jump2d")
local move = require("mini.move")
local nabla = require("nabla")
local oil = require("oil")
local splitjoin = require("mini.splitjoin")
local surround = require("mini.surround")
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local telescope_themes = require("telescope.themes")
local todos = require("todo-comments")
local wk = require("which-key")

-- [[ augroups ]] -------------------------------------------------------
local ft_group = augroup("UserFiletypeKeymaps", { clear = true })

-- [[ leader key ]] -----------------------------------------------------
g.mapleader = " "
g.maplocalleader = ","
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- [[ multi cursor ]] ---------------------------------------------------
g.multi_cursor_use_default_mapping = 0
g.VM_mouse_mappings = 1

-- [[ which-key settings ]] ---------------------------------------------
wk.setup({ window = { border = "single", position = "bottom" } })

-- [[ functions ]] ------------------------------------------------------
local buffer = {
	search = function()
		telescope_builtin.current_buffer_fuzzy_find(telescope_themes.get_dropdown({
			previewer = false,
			winblend = 10,
		}))
	end,
	format = function()
		formatters.format({
			timeout_ms = 500,
			lsp_fallback = true,
		})
	end,
}

local git = {
	stage_hunk = function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	reset_hunk = function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	blame_line = function()
		gitsigns.blame_line({ full = true })
	end,
}

local files = {
	find = function()
		telescope_builtin.find_files({
			hidden = true,
		})
	end,
}

local section = function(key, name, prefix, mode)
	wk.register({
		[key] = { name = name },
	}, { prefix = prefix, mode = mode })
end

-- [[ keymaps ]] --------------------------------------------------------
-- remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- exit mode pressing 'jk'
map("i", "jk", "<ESC>", { noremap = true, silent = true })
map("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })

-- resize windows
map("n", "+", "<cmd>resize +2<cr>", { noremap = true, silent = true })
map("n", "-", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true })
map("n", "=", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true })
map("n", "_", "<cmd>resize -2<cr>", { noremap = true, silent = true })

-- quickfix
section("q", "quickfix", "<localleader>", "n")
map("n", "<localleader>qo", "<cmd>copen<cr>", { desc = "Open" })
map("n", "<localleader>qq", "<cmd>cclose<cr>", { desc = "Close" })

-- buffers
section("b", "buffers", "<leader>", "n")
map("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
map("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next" })
map("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous" })
map("n", "<leader>bw", bufremove.wipeout, { desc = "Wipeout" })
map("n", "<leader>bo", "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all other buffers" })
map("n", "<leader><space>", telescope_builtin.buffers, { desc = "List buffers" })
map("n", "<leader>/", buffer.search, { desc = "Search in current buffer" })

-- debugger
section("d", "debugger", "<leader>", "n")
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", dap.step_back, { desc = "Step back" })
map("n", "<leader>dc", dap.continue, { desc = "Continue" })
map("n", "<leader>di", dap.step_back, { desc = "Step into" })
map("n", "<leader>do", dap.step_over, { desc = "Step over" })
map("n", "<leader>dp", dap.pause, { desc = "Pause" })
map("n", "<leader>dq", dap.close, { desc = "Quit" })
map("n", "<leader>dt", dap_ui.toggle, { desc = "Toggle UI" })
map("n", "<leader>du", dap.step_out, { desc = "Step out" })
map("n", "<localleader>e", dap_ui.eval, { desc = "Evaluate [DAP]" })

-- files
section("f", "files", "<leader>", "n")
map("n", "<leader>ff", files.find, { desc = "Find all files" })
map("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
map("n", "<leader>fG", telescope_builtin.git_files, { desc = "Git files" })

-- git
section("g", "git", "<leader>", { "n", "v" })
map("n", "<leader>gB", telescope_builtin.git_bcommits, { desc = "Commits (buffer)" })
map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
map("n", "<leader>gb", telescope_builtin.git_branches, { desc = "Branches" })
map("n", "<leader>gc", telescope_builtin.git_commits, { desc = "Commits" })
map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>gl", git.blame_line, { desc = "Blame line" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>gt", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
map("v", "<leader>gr", git.reset_hunk, { desc = "Reset hunk" })
map("v", "<leader>gs", git.stage_hunk, { desc = "Stage hunk" })
map("n", "]h", gitsigns.next_hunk, { desc = "Next hunk" })
map("n", "[h", gitsigns.prev_hunk, { desc = "Previous hunk" })

-- todos
vim.keymap.set("n", "]t", todos.jump_next, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", todos.jump_prev, { desc = "Previous todo comment" })

-- orgmode
section("o", "orgmode", "<leader>", "n")
map("n", "<leader>of", telescope.extensions.orgmode.search_headings, { desc = "org search headings" })

-- repl
section("r", "REPL", "<leader>", "n")
map("n", "<space>rs", "<cmd>IronRepl<cr>", { desc = "Open" })
map("n", "<space>rr", "<cmd>IronRestart<cr>", { desc = "Restart" })
map("n", "<space>rf", "<cmd>IronFocus<cr>", { desc = "Focus" })
map("n", "<space>rh", "<cmd>IronHide<cr>", { desc = "Hide" })

-- windows
section("w", "windows", "<leader>", "n")
map("n", "<leader>wd", "<C-w>q", { desc = "Close" })
map("n", "<leader>wn", "<C-w>w", { desc = "Next" })
map("n", "<leader>wp", "<C-w>p", { desc = "Previous" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split" })
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>wx", "<C-w>x", { desc = "Swap" })

-- random
map("n", "<leader>Z", telescope.extensions.zoxide.list, { desc = "Zoxide" })
map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>h", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer (tree)" })
map("n", "<leader>c", "<cmd>nohl<cr>", { desc = "Clear highlights" })
map("n", "<leader>.", oil.open, { desc = "File manager" })

-- markdown
autocmd("FileType", {
	pattern = "markdown",
	group = ft_group,
	callback = function()
		map({ "n", "i" }, "<C-b>", "<cmd>Telescope bibtex<cr>", { desc = "Insert reference" })
		map("n", "<localleader>p", "<cmd>MarkdownPreview<cr>", { desc = "Preview markdown file" })
		map("n", "<localleader>e", nabla.toggle_virt, { desc = "Toggle equation preview" })
	end,
})

-- orgmode
autocmd("FileType", {
	pattern = "org",
	group = ft_group,
	callback = function()
		map({ "n", "i" }, "<C-b>", "<cmd>Telescope bibtex<cr>", { desc = "Insert reference" })
	end,
})

-- [[ mini stuff ]] -----------------------------------------------------
-- moving around buffer
jump2d.setup({ mappings = { start_jumping = "<leader>j" } })

-- split and join arguments
splitjoin.setup({ mappings = { toggle = "<leader>t" } })

-- surround text objects
section("s", "surround", "<leader>", { "n", "v" })
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
		left = "<M-h>",
		right = "<M-l>",
		down = "<M-j>",
		up = "<M-k>",
		-- normal mode
		line_left = "<M-h>",
		line_right = "<M-l>",
		line_down = "<M-j>",
		line_up = "<M-k>",
	},
})
