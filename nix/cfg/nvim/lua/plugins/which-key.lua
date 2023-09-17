local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local buf = vim.lsp.buf
local bufremove = require("mini.bufremove")
local dap = require("dap")
local dap_ui = require("dapui")
local diag = vim.diagnostic
local gitsigns = require("gitsigns")
local oil = require("oil")
local wk = require("which-key")

-- formatting function
local lsp_formatting = function()
	buf.format({
		timeout_ms = 500,
		async = true,
		filter = function(client)
			return client.name == "efm"
		end,
	})

	vim.cmd([[write]])
end

-- which-key configuration
local conf = {
	window = {
		border = "single",
		position = "bottom",
	},
}

-- lsp mappings
local lsp = {
	g = {
		normal = {
			options = {
				mode = "n",
				prefix = "g",
				buffer = nil,
				silent = true,
				noremap = true,
				nowait = false,
			},
			mappings = {
				R = { "<cmd>Telescope lsp_references<cr>", "LSP - References" },
				d = { "<cmd>Telescope lsp_definitions<cr>", "LSP - Definitions" },
				i = { "<cmd>Telescope lsp_implementations<cr>", "LSP - Implementation" },
				t = { "<cmd>Telescope lsp_type_definitions<cr>", "LSP - Type definition" },
				a = {
					function()
						buf.code_action()
					end,
					"LSP - Code action",
				},
				D = {
					function()
						buf.declaration()
					end,
					"LSP - Declaration",
				},
				h = {
					function()
						buf.hover()
					end,
					"LSP - Hover",
				},
				r = {
					function()
						buf.rename()
					end,
					"LSP - Rename",
				},
				s = {
					function()
						buf.signature_help()
					end,
					"LSP - Signature help",
				},
			},
		},
		visual = {
			options = {
				mode = "v",
				prefix = "g",
				buffer = nil,
				silent = true,
				noremap = true,
				nowait = false,
			},
			mappings = {
				a = {
					function()
						buf.code_action()
					end,
					"LSP - Code action",
				},
			},
		},
	},
	leader = {
		normal = {
			options = {
				mode = "n",
				prefix = "<leader>",
				buffer = nil,
				silent = true,
				noremap = true,
				nowait = false,
			},
			mappings = {
				d = {
					name = "+debugger",
					B = {
						function()
							dap.step_back()
						end,
						"Step back",
					},
					c = {
						function()
							dap.continue()
						end,
						"Continue",
					},
					i = {
						function()
							dap.step_into()
						end,
						"Step into",
					},
					o = {
						function()
							dap.step_over()
						end,
						"Step over",
					},
					p = {
						function()
							dap.pause()
						end,
						"Pause",
					},
					q = {
						function()
							dap.close()
						end,
						"Quit",
					},
					s = {
						function()
							dap.continue()
						end,
						"Start",
					},
					t = {
						function()
							dap_ui.toggle()
						end,
						"Toggle UI",
					},
					u = {
						function()
							dap.step_out()
						end,
						"Step out",
					},
					b = {
						function()
							dap.toggle_breakpoint()
						end,
						"Toggle breakpoint",
					},
					r = {
						function()
							dap_ui.open({ reset = true })
						end,
						"Reset UI panes",
					},
				},
				l = {
					name = "+lsp",
					d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
					s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
					w = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols" },
					r = { "<cmd>LspRestart<cr>", "Restart" },
					c = {
						function()
							vim.lsp.codelens.run()
						end,
						"CodeLens action",
					},
					l = {
						function()
							diag.setloclist()
						end,
						"Loclist",
					},
					n = {
						function()
							diag.goto_next()
						end,
						"Next diagnostic",
					},
					o = {
						function()
							diag.open_float()
						end,
						"Open float",
					},
					p = {
						function()
							diag.goto_prev()
						end,
						"Previous diagnostic",
					},
					f = {
						function()
							lsp_formatting()
						end,
						"Format",
					},
				},
			},
		},
	},
	local_leader = {
		visual = {
			options = {
				mode = "v",
				prefix = ",",
				buffer = nil,
				silent = true,
				noremap = true,
				nowait = false,
			},
			mappings = {
				e = {
					function()
						dap_ui.eval()
					end,
					"Debugger - Evaluate",
				},
			},
		},
	},
}

-- local leader mappings
local local_leader = {
	normal = {
		options = {
			mode = "n",
			prefix = ",",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = false,
		},
		mappings = {
            s = { name = "+swap" },
			q = {
				name = "+quickfix",
				o = { "<cmd>copen<cr>", "Open" },
				q = { "<cmd>cclose<cr>", "Close" },
			},
		},
	},
}

-- leader mappings
local leader = {
	normal = {
		options = {
			mode = "n",
			prefix = "<leader>",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = false,
		},
		mappings = {
			Z = { "<cmd>Telescope zoxide list<cr>", "Zoxide" },
			c = { "<cmd>noh<cr>", "Clear highlights" },
			e = { "<cmd>NvimTreeToggle<cr>", "Explorer (tree)" },
			h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
			q = { "<cmd>confirm q<cr>", "Quit" },
			u = { "<cmd>UndotreeToggle<cr>", "Undo tree" },
			z = { "<cmd>ZenMode<cr>", "Zen mode" },
			s = { name = "+surround" },
			b = {
				name = "+buffers",
				G = { "<cmd>bl<cr>", "Last buffer" },
				b = { "<cmd>Telescope buffers previewer=false<cr>", "Buffers" },
				d = {
					function()
						bufremove.delete()
					end,
					"Delete buffer",
				},
				f = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find" },
				g = { "<cmd>bf<cr>", "First buffer" },
				n = { "<cmd>bn<cr>", "Next buffer" },
				p = { "<cmd>bp<cr>", "Previous buffer" },
				o = { "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", "Close all other buffers" },
				w = {
					function()
						bufremove.wipeout()
					end,
					"Wipeout buffers",
				},
				s = {
					name = "+split",
					p = { "<cmd>sbp<cr>", "Previous buffer" },
					n = { "<cmd>sbn<cr>", "Next buffer" },
				},
			},
			f = {
				name = "+files",
				["."] = {
					function()
						oil.open()
					end,
					"File explorer",
				},
				G = { "<cmd>Telescope git_files<cr>", "Find (git files)" },
				c = { "<cmd>Telescope grep_string<cr>", "Find string in cursor" },
				f = { "<cmd>Telescope find_files hidden=true<cr>", "Find" },
				g = { "<cmd>Telescope live_grep<cr>", "Live grep in project" },
				r = { "<cmd>Telescope oldfiles<cr>", "Open recent file" },
				s = { "<cmd>w<cr>", "Save" },
				t = { "<cmd>TodoTelescope<cr>", "Search TODOs" },
			},
			g = {
				name = "+git",
				B = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit (buffer)" },
				C = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
				D = { "<cmd>Gdiff<cr>", "Diff file (editor)" },
				L = { "<cmd>Gllog<cr>", "Log (project)" },
				l = { "<cmd>G log %<cr>", "Log (file)" },
				P = { "<cmd>G push<cr>", "Push" },
				b = { "<cmd>G blame<cr>", "Blame" },
				c = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				d = { "<cmd>G diff %<cr>", "Diff file" },
				g = { "<cmd>G<cr>", "Git" },
				p = { "<cmd>G pull<cr>", "Pull" },
				r = {
					function()
						gitsigns.reset_buffer()
					end,
					"Reset buffer",
				},
			},
			o = {
				name = "Orgmode",
				f = { "<cmd>Telescope orgmode search_headings<cr>", "org search headings" },
			},
			r = {
				name = "+REPL",
				f = { "<cmd>IronFocus<cr>", "Focus" },
				h = { "<cmd>IronHide<cr>", "Hide" },
				o = { "<cmd>IronRepl<cr>", "Open" },
				r = { "<cmd>IronRestart<cr>", "Restart" },
			},
			T = {
				name = "+tabs",
				d = { "<cmd>tabclose<cr>", "Close" },
				n = { "<cmd>tabnext<cr>", "Next" },
				p = { "<cmd>tabprevious<cr>", "Previous" },
				t = { "<cmd>tabnew<cr>", "New" },
			},
			w = {
				name = "+windows",
				d = { "<C-w>q", "Close" },
				n = { "<C-w>w", "Next" },
				p = { "<C-w>p", "Previous" },
				s = { "<C-w>s", "Split" },
				v = { "<C-w>v", "Vertical split" },
				x = { "<C-w>x", "Swap" },
			},
		},
	},
	visual = {
		options = {
			mode = "v",
			prefix = "<leader>",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = false,
		},
		mappings = {
			s = { name = "+surround" },
		},
	},
}

-- apply mappings
wk.setup(conf)
wk.register(leader.normal.mappings, leader.normal.options)
wk.register(leader.visual.mappings, leader.visual.options)
wk.register(local_leader.normal.mappings, local_leader.normal.options)

autocmd("LspAttach", {
	group = augroup("UserLspConfig", { clear = true }),
	callback = function()
		wk.register(lsp.g.normal.mappings, lsp.g.normal.options)
		wk.register(lsp.g.visual.mappings, lsp.g.visual.options)
		wk.register(lsp.leader.normal.mappings, lsp.leader.normal.options)
		wk.register(lsp.local_leader.visual.mappings, lsp.local_leader.visual.options)
	end,
})
