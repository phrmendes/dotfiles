local setup, obsidian = pcall(require, "obsidian")
if not setup then
	return
end

obsidian.setup({
	dir = "~/pCloudDrive/notes",
	completion = {
		nvim_cmp = true,
	},
})
