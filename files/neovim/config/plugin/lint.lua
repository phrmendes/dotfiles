safely("later", function()
  require("lint").linters_by_ft = {
    astro = { "oxlint" },
    bash = { "shellcheck" },
    htmldjango = { "djlint" },
    jinja2 = { "djlint" },
    javascript = { "oxlint" },
    jsx = { "oxlint" },
    sh = { "shellcheck" },
    terraform = { "tflint" },
    tsx = { "oxlint" },
    typescript = { "oxlint" },
    ["yaml.ansible"] = { "ansible-lint" },
    zsh = { "shellcheck" },
  }

  safely("event:BufWritePost,BufReadPost,InsertLeave", function() require("lint").try_lint() end)
end)
