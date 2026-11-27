local icons = {
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = " ",
  Stopped = " ",
}

local configs = {
  {
    type = "python",
    request = "launch",
    name = "fastapi:server",
    module = "fastapi",
    args = function() return { "run", vim.fn.input("Entrypoint: ", "src/main.py"), "--port", vim.fn.input("Port: ", "8000") } end,
    justMyCode = true,
    console = "integratedTerminal",
  },
  {
    type = "python",
    name = "remote",
    request = "attach",
    mode = "remote",
    connect = function()
      return {
        host = vim.fn.input("Host: ", "localhost"),
        port = tonumber(vim.fn.input("Port: ", "5678")),
      }
    end,
    pathMappings = function()
      return {
        {
          localRoot = vim.fn.input("Local path: ", "${workspaceFolder}"),
          remoteRoot = vim.fn.input("Remote path: ", "."),
        },
      }
    end,
  },
  {
    type = "lua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

local adapters = {
  lua = { type = "server", host = "127.0.0.1", port = 8086 },
}

safely("later", function()
  local dap = require("dap")
  local dap_view = require("dap-view")

  dap.listeners.before.attach["dap-view-config"] = function() dap_view.open() end
  dap.listeners.before.launch["dap-view-config"] = function() dap_view.open() end
  dap.listeners.before.event_terminated["dap-view-config"] = function() dap_view.close() end
  dap.listeners.before.event_exited["dap-view-config"] = function() dap_view.close() end

  require("dap-python").setup("debugpy-adapter")

  vim.iter(icons):each(
    ---@param type string
    ---@param icon string
    function(type, icon)
      local thl = "Dap" .. type
      local nhl = (type == "Stopped") and "DapStop" or "DapBreak"
      vim.fn.sign_define(thl, { text = icon, texthl = thl, numhl = nhl })
    end
  )

  vim.iter(configs):each(
    ---@param config dap.Configuration
    function(config)
      local type = config.type

      dap.configurations[type] = dap.configurations[type] or {}
      table.insert(dap.configurations[type], config)
    end
  )

  vim.iter(adapters):each(function(lang, adapter) dap.adapters[lang] = adapter end)
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua", "rust", "go" },
  callback = function(event)
    local dap = require("dap")
    local dap_view = require("dap-view")
    local opts = function(desc) return { buffer = event.buf, desc = desc } end

    vim.keymap.set("n", "<F7>", dap.step_back, opts("DAP: step back"))
    vim.keymap.set("n", "<F8>", dap.continue, opts("DAP: continue"))
    vim.keymap.set("n", "<F9>", dap.step_over, opts("DAP: step over"))
    vim.keymap.set("n", "<S-F8>", dap.pause, opts("DAP: pause"))
    vim.keymap.set("n", "<BS>", dap.close, opts("DAP: close"))
    vim.keymap.set("n", "<localleader>d", "", opts("+dap"))
    vim.keymap.set("n", "<localleader>dd", dap.run_last, opts("Debug last"))
    vim.keymap.set("n", "<localleader>di", dap.step_into, opts("Step into"))
    vim.keymap.set("n", "<localleader>do", dap.step_out, opts("Step out"))
    vim.keymap.set("n", "<localleader>dq", dap.terminate, opts("Terminate"))
    vim.keymap.set("n", "<localleader>du", dap_view.toggle, opts("Toggle UI"))
    vim.keymap.set("n", "<localleader>d<del>", dap.clear_breakpoints, opts("Clear breakpoints"))
    vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint, opts("Breakpoint"))
    vim.keymap.set("n", "<localleader>dB", function()
      vim.ui.input({ prompt = "Condition: " }, function(input) dap.set_breakpoint(input) end)
    end, opts("Conditional breakpoint"))
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  once = true,
  callback = function() require("dap-go").setup() end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(event)
    vim.keymap.set("n", "<localleader>df", function() require("dap-go").debug_test() end, { buffer = event.buf, desc = "Debug test" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(event)
    local dap_python = require("dap-python")

    vim.keymap.set("n", "<localleader>dc", dap_python.test_class, { buffer = event.buf, desc = "Debug class" })
    vim.keymap.set("n", "<localleader>df", dap_python.test_method, { buffer = event.buf, desc = "Debug function/method" })
    vim.keymap.set("x", "<localleader>ds", dap_python.debug_selection, { buffer = event.buf, desc = "Debug selection" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(event)
    vim.keymap.set("n", "<localleader>dl", function() require("osv").launch({ port = 8086 }) end, { buffer = event.buf, desc = "Launch debugger" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  once = true,
  callback = function() require("dap-lldb").setup() end,
})
