local M = {
	random = function()
		vim.api.nvim_create_user_command("Spell", function(args)
			if #args.fargs == 0 then
				vim.g.spell_enabled = not vim.g.spell_enabled
				vim.opt_local.spell = vim.g.spell_enabled

				vim.notify("Spell " .. (vim.g.spell_enabled and "enabled" or "disabled"))

				return
			end

			if args.fargs[1] == "pt" then
				vim.opt_local.spell = true
				vim.opt_local.spelllang = "pt"
				vim.notify("Spell language set to `pt`")
				return
			end

			if args.fargs[1] == "en" then
				vim.opt_local.spell = true
				vim.opt_local.spelllang = "en"
				vim.notify("Spell language set to `en`")
				return
			end
		end, {
			desc = "Select language",
			nargs = "*",
		})
	end,
}

M.setup = function()
	M.random()
end

return M
