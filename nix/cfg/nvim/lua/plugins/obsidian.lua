local status, obsidian = pcall(require, "obsidian")
if not status then return end

obsidian.setup({ dir = "~/pCloudDrive/notes", completion = { nvim_cmp = true } })
