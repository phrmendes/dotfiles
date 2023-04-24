local setup, dapui = pcall(require, "dapui")
if not setup then
	return
end

dapui.setup()
