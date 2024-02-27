local utils = require("utils")

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		if vim.fn.has("mac") == 0 then
			require("octo").setup({
				suppress_missing_scope = {
					project_v2 = true,
				},
			})
		end

		utils.map({
			key = "]h",
			desc = "Next hunk",
			buffer = bufnr,
			cmd = function()
				if vim.wo.diff then
					return "]h"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end,
		}, {
			expr = true,
		})

		utils.map({
			key = "[h",
			desc = "Previous hunk",
			buffer = bufnr,
			cmd = function()
				if vim.wo.diff then
					return "[h"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end,
		}, {
			expr = true,
		})

		utils.section({
			mode = { "n", "v" },
			key = "<leader>g",
			name = "git",
		})

		utils.map({
			key = "<leader>gd",
			cmd = gs.diffthis,
			desc = "Diff against index",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>gD",
			buffer = bufnr,
			desc = "Diff against last commit",
			cmd = function()
				gs.diffthis("~")
			end,
		})

		utils.map({
			key = "<leader>gs",
			cmd = "<CMD>Telescope git_status<CR>",
			desc = "Diff (repo)",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>gt",
			cmd = gs.toggle_current_line_blame,
			desc = "Toggle blame line",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>gb",
			cmd = gs.stage_buffer,
			desc = "Stage buffer",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>gB",
			cmd = gs.reset_buffer,
			desc = "Reset buffer",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>gh",
			cmd = gs.stage_hunk,
			desc = "Stage hunk",
			buffer = bufnr,
		})

		utils.map({
			mode = "v",
			key = "<leader>gh",
			desc = "Stage",
			buffer = bufnr,
			cmd = function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
		})

		utils.map({
			key = "<leader>gH",
			cmd = gs.reset_hunk,
			desc = "Reset hunk",
			buffer = bufnr,
		})

		utils.map({
			mode = "v",
			key = "<leader>gH",
			desc = "Reset hunk",
			buffer = bufnr,
			cmd = function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
		})

		utils.map({
			key = "<leader>gc",
			cmd = "<CMD>LazyGitFilter<CR>",
			desc = "Repository",
		})

		utils.map({
			key = "<leader>gC",
			cmd = "<CMD>LazyGitFilterCurrentFile<CR>",
			desc = "File",
		})

		utils.map({
			key = "<leader>gg",
			cmd = "<CMD>LazyGit<CR>",
			desc = "LazyGit",
		})

		utils.map({
			key = "<leader>gl",
			cmd = "<CMD>Telescope lazygit<CR>",
			desc = "List repos",
		})
	end,
})
