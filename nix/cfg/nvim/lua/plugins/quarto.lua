local setup, quarto = pcall(require, "quarto")
if not setup then
return
end

quarto.setup()
