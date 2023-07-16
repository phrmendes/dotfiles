local setup, project = pcall(require, "project_nvim")
if not setup then return end

project.setup({
    detection_methods = { "pattern" },
    patterns = { ".git", ">Projects" },
    show_hidden = true
})
