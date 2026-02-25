return function(client, bufnr)
  local Methods = vim.lsp.protocol.Methods
  local select = vim.lsp.inline_completion.select

  local opts = function(desc) return { buffer = bufnr, desc = "LSP: " .. desc } end
  local supports = function(method) return client:supports_method(method, bufnr) end
  local picker = function(scope)
    return function() MiniExtra.pickers.lsp({ scope = scope }) end
  end

  vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, opts("go to next reference"))
  vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, opts("go to previous reference"))
  vim.keymap.set("n", "<leader>d", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end, opts("diagnostics"))
  vim.keymap.set("n", "<leader>D", function() MiniExtra.pickers.diagnostic({ scope = "all" }) end, opts("workspace diagnostics"))
  vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts("diagnostics (float)"))

  local mappings = {
    { Methods.textDocument_rename, "n", "<f2>", vim.lsp.buf.rename, "rename symbol" },
    { Methods.textDocument_definition, "n", "gd", picker("definition"), "go to definition" },
    { Methods.textDocument_declaration, "n", "gD", picker("declaration"), "go to declaration" },
    { Methods.textDocument_implementation, "n", "gi", picker("implementation"), "go to implementations" },
    { Methods.textDocument_references, "n", "gr", picker("references"), "go to references" },
    { Methods.textDocument_typeDefinition, "n", "gt", picker("type_definition"), "go to type definition" },
    { Methods.textDocument_codeAction, { "n", "x" }, "<leader>a", vim.lsp.buf.code_action, "code actions" },
    { Methods.textDocument_signatureHelp, { "n", "x" }, "<leader>h", vim.lsp.buf.signature_help, "signature help" },
    { Methods.textDocument_inlayHint, "n", "<leader>i", Snacks.toggle.inlay_hints, "toggle inlay hints" },
    { Methods.textDocument_hover, "n", "K", vim.lsp.buf.hover, "hover" },
    { Methods.textDocument_documentSymbol, "n", "<leader>s", picker("document_symbol"), "symbols (document)" },
    { Methods.workspace_symbol, "n", "<leader>S", picker("workspace_symbol"), "symbols (workspace)" },
    { Methods.textDocument_inlineCompletion, "i", "<c-l>", vim.lsp.inline_completion.get, "accept inline completion" },
    { Methods.textDocument_inlineCompletion, "i", "<m-]>", function() select({ bufnr = bufnr, count = vim.v.count1 }) end, "next completion" },
    { Methods.textDocument_inlineCompletion, "i", "<m-[>", function() select({ bufnr = bufnr, count = -vim.v.count1 }) end, "previous completion" },
    { Methods.workspace_didRenameFiles or Methods.workspace_willRenameFiles, "n", "<leader>R", Snacks.rename.rename_file, "rename file" },
  }

  vim.iter(mappings):filter(function(m) return supports(m[1]) end):each(function(m) vim.keymap.set(m[2], m[3], m[4], opts(m[5])) end)
end
