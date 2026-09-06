safely("later", function()
  require("lint").linters_by_ft = {
    astro = { "oxlint" },
    bash = { "shellcheck" },
    htmldjango = { "djlint" },
    javascript = { "oxlint" },
    jinja2 = { "djlint" },
    jsx = { "oxlint" },
    rust = { "clippy" },
    sh = { "shellcheck" },
    terraform = { "tflint" },
    tsx = { "oxlint" },
    typescript = { "oxlint" },
    ["yaml.ansible"] = { "ansible_lint" },
  }

  safely("event:BufWritePost,BufReadPost,InsertLeave", function() require("lint").try_lint() end)
end)
