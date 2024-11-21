if vim.env.TMUX then
	vim.cmd([[let test#strategy = 'vimux']])
else
	vim.cmd([[let test#strategy = 'wezterm']])
end

vim.cmd([[let test#python#runner = 'pytest']])
vim.cmd([[let test#elixir#runner = 'exunit']])
vim.cmd([[let test#go#runner = 'gotest']])
