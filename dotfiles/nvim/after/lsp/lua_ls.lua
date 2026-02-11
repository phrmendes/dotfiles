return {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      globals = { "vim", "Snacks", "MiniDeps" },
      diagnostics = { disable = { "missing-fields" } },
    },
  },
}
