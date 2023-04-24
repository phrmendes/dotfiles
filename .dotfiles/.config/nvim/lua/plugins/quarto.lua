local sttatus, quarto = pcall(require, "quarto")
if not sttatus then
	return
end

quarto.setup()
