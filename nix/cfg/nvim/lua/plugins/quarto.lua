local setup, quarto = pcall(require, "quarto")
if not setup then return end

quarto.setup({
    keymap = { hover = "gh", definition = "gd", rename = "gr", references = "gR" }
})
