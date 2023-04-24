local setup, autoclose = pcall(require, "autoclose")
if not setup then
	return
end

autoclose.setup()
