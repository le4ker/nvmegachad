local T = require("test_helper")

T.test("Conform plugin metadata and Python formatter options are configured", function()
  local spec = require("plugins.conform")
  local opts = spec.opts

  T.eq(spec[1], "stevearc/conform.nvim")
  T.eq(spec.event, "BufWritePre")

  assert(next(opts.formatters_by_ft), "Conform filetype map is empty")
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
