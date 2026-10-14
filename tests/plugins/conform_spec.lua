local T = require("test_helper")

T.test("Conform maps supported filetypes to their intended formatters", function()
  local spec = require("plugins.conform")
  local opts = spec.opts
  local expected = {
    c = { "clang-format" },
    cpp = { "clang-format" },
    css = { "prettier" },
    dockerfile = { "dockerfmt" },
    go = { "goimports" },
    graphql = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    make = { "bake" },
    markdown = { "prettier" },
    python = { "isort", "black" },
    scss = { "prettier" },
    sh = { "shfmt" },
    sql = { "sql_formatter" },
    ruby = { "rubocop" },
    terraform = { "terraform_fmt" },
    toml = { "taplo" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    yaml = { "prettier" },
    zsh = { "shfmt" },
  }

  T.eq(spec[1], "stevearc/conform.nvim")
  T.eq(spec.event, "BufWritePre")

  local actual_count = 0
  for filetype, formatters in pairs(opts.formatters_by_ft) do
    actual_count = actual_count + 1
    local expected_formatters = expected[filetype]
    assert(expected_formatters, "unexpected formatter entry for " .. filetype)
    T.eq(#formatters, #expected_formatters, "wrong formatter count for " .. filetype)
    for index, formatter in ipairs(formatters) do
      T.eq(formatter, expected_formatters[index], "wrong formatter for " .. filetype)
    end
  end
  T.eq(actual_count, vim.tbl_count(expected), "a filetype formatter entry is missing")
  T.eq(table.concat(opts.formatters.isort.prepend_args, " "), "--profile black")
end)

T.test("every configured formatter is provisioned by Mason or declared external", function()
  local formatters = require("plugins.conform").opts.formatters_by_ft
  local mason_tools = require("plugins.mason").opts.ensure_installed
  local installed = {}
  for _, tool in ipairs(mason_tools) do
    installed[tool] = true
  end

  local package_names = {
    bake = "mbake",
    sql_formatter = "sql-formatter",
  }
  local external = { terraform_fmt = true }

  for filetype, names in pairs(formatters) do
    for _, formatter in ipairs(names) do
      local package = package_names[formatter] or formatter
      assert(
        installed[package] or external[formatter],
        ("formatter %q for %s is neither installed by Mason nor declared external"):format(
          formatter,
          filetype
        )
      )
    end
  end
end)
