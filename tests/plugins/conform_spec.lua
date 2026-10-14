local T = require("test_helper")

T.test("Conform maps supported filetypes to their intended formatters", function()
  local spec = require("plugins.conform")
  local opts = spec.opts

  T.eq(spec[1], "stevearc/conform.nvim")
  T.eq(spec.event, "BufWritePre")
  T.eq(table.concat(opts.formatters_by_ft.python, ","), "isort,black")
  T.eq(opts.formatters_by_ft.make[1], "bake")
  T.eq(opts.formatters_by_ft.go[1], "goimports")
  T.eq(opts.formatters_by_ft.lua[1], "stylua")
  T.eq(table.concat(opts.formatters.isort.prepend_args, " "), "--profile black")
end)

T.test("Conform format-on-save callback follows the global toggle", function()
  local format_on_save = require("plugins.conform").opts.format_on_save

  vim.g.format_on_save = false
  T.eq(format_on_save(), nil)
  vim.g.format_on_save = true
  local opts = format_on_save()
  T.eq(opts.lsp_format, "fallback")
  T.eq(opts.timeout_ms, 1000)
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
