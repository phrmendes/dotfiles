local utils = require("utils")

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		if vim.fn.has("mac") == 0 then
			require("octo").setup()
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

		utils.section({
			mode = { "n", "v" },
			key = "<leader>gb",
			name = "buffer",
		})

		utils.section({
			mode = { "n", "v" },
			key = "<leader>gh",
			name = "hunk",
		})

		utils.section({
			mode = { "n", "v" },
			key = "<leader>gc",
			name = "commits",
		})

		utils.map({
			key = "<leader>gB",
			cmd = "<CMD>Telescope git_branches<CR>",
			desc = "Branches",
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
			key = "<leader>gbr",
			cmd = gs.reset_buffer,
			desc = "Reset",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>gbs",
			cmd = gs.stage_buffer,
			desc = "Stage",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>ghp",
			cmd = gs.preview_hunk,
			desc = "Preview",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>ghr",
			cmd = gs.reset_hunk,
			desc = "Reset",
			buffer = bufnr,
		})

		utils.map({
			mode = "v",
			key = "<leader>ghr",
			desc = "Reset",
			buffer = bufnr,
			cmd = function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
		})

		utils.map({
			key = "<leader>ghs",
			cmd = gs.stage_hunk,
			desc = "Stage",
			buffer = bufnr,
		})

		utils.map({
			mode = "v",
			key = "<leader>ghs",
			desc = "Stage",
			buffer = bufnr,
			cmd = function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
		})

		utils.map({
			key = "<leader>ghu",
			cmd = gs.undo_stage_hunk,
			desc = "Undo stage",
			buffer = bufnr,
		})

		utils.map({
			key = "<leader>gcr",
			cmd = "<CMD>LazyGitFilter<CR>",
			desc = "Repository",
		})

		utils.map({
			key = "<leader>gcf",
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
