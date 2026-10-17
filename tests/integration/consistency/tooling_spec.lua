local T = require("test_helper")
local setup_lint = require("support.lint").setup_lint
local setup_lspconfig = require("support.lsp").setup_lspconfig

local function mason_packages()
  local packages = {}
  for _, package in ipairs(require("plugins.mason").opts.ensure_installed) do
    packages[package] = true
  end
  return packages
end

T.test("every enabled LSP server is provided by Mason", function()
  local mason = mason_packages()
  local names = {
    bashls = "bash-language-server",
    clangd = "clangd",
    cssls = "css-lsp",
    dockerls = "dockerfile-language-server",
    gopls = "gopls",
    html = "html-lsp",
    jsonls = "json-lsp",
    lua_ls = "lua-language-server",
    marksman = "marksman",
    pyright = "pyright",
    ruby_lsp = "ruby-lsp",
    taplo = "taplo",
    terraformls = "terraform-ls",
    ts_ls = "typescript-language-server",
    vimls = "vim-language-server",
    yamlls = "yaml-language-server",
  }
  for _, server in ipairs(setup_lspconfig().enabled) do
    assert(mason[names[server]], "LSP package missing from Mason: " .. server)
  end
end)

T.test("every configured linter is provided by Mason", function()
  local mason = mason_packages()
  local lint_map = { golangcilint = "golangci-lint" }
  for _, linters in pairs(setup_lint().linters_by_ft) do
    for _, linter in ipairs(linters) do
      assert(mason[lint_map[linter] or linter], "linter package missing from Mason: " .. linter)
    end
  end
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

T.test("every custom LSP config has an enabled server", function()
  local seen = {}
  for _, name in ipairs(setup_lspconfig().enabled) do
    seen[name] = true
  end
  for _, path in ipairs(vim.fn.glob("lsp/*.lua", false, true)) do
    local server = vim.fn.fnamemodify(path, ":t:r")
    assert(seen[server], "custom LSP config has no enabled server: " .. server)
  end
end)

T.test("the Mason package list has no duplicates", function()
  local tools = {}
  for _, tool in ipairs(require("plugins.mason").opts.ensure_installed) do
    assert(not tools[tool], "duplicate Mason package: " .. tool)
    tools[tool] = true
  end
end)

T.test("enabled LSP servers match the expected set", function()
  local enabled = setup_lspconfig().enabled

  local expected = {
    "bashls",
    "clangd",
    "cssls",
    "dockerls",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "pyright",
    "ruby_lsp",
    "taplo",
    "terraformls",
    "ts_ls",
    "vimls",
    "yamlls",
  }
  table.sort(enabled)
  T.eq(
    enabled,
    expected,
    "update this list together with the enabled servers and their Mason packages"
  )
end)

T.test("linters by filetype match the expected mapping", function()
  T.eq(setup_lint().linters_by_ft, {
    dockerfile = { "hadolint" },
    go = { "golangcilint" },
    make = { "checkmake" },
    markdown = { "markdownlint" },
    python = { "pylint" },
    sh = { "shellcheck" },
    terraform = { "tflint" },
  }, "update this mapping together with the Mason packages")
end)

T.test("formatters by filetype match the expected mapping", function()
  T.eq(require("plugins.conform").opts.formatters_by_ft, {
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
    ruby = { "rubocop" },
    scss = { "prettier" },
    sh = { "shfmt" },
    sql = { "sql_formatter" },
    terraform = { "terraform_fmt" },
    toml = { "taplo" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    yaml = { "prettier" },
    zsh = { "shfmt" },
  }, "update this mapping together with the Mason packages")
end)
