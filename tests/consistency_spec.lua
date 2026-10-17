local T = require("test_helper")

T.test("every plugin file returns a valid Lazy spec or list of specs", function()
  for _, path in ipairs(vim.fn.glob("lua/plugins/*.lua", false, true)) do
    local result = dofile(path)
    assert(type(result) == "table", path .. " must return a table")
    local specs = result[1] and type(result[1]) == "string" and { result } or result
    assert(#specs > 0, path .. " returned no plugin specs")
    for _, spec in ipairs(specs) do
      assert(type(spec) == "table", path .. " contains a non-table plugin spec")
      assert(type(spec[1]) == "string", path .. " spec is missing its plugin name")
    end
  end
end)

T.test("enabled LSP servers and configured linters are provided by Mason", function()
  local enabled = {}
  T.stub(vim.lsp, "config", function() end)
  T.stub(vim.lsp, "enable", function(servers)
    enabled = servers
  end)
  do
    T.with_modules({
      ["nvchad.configs.lspconfig"] = { defaults = function() end },
      ["blink.cmp"] = {
        get_lsp_capabilities = function()
          return {}
        end,
      },
    }, function()
      require("configs.plugins.lspconfig").setup()
    end)
    local mason = {}
    for _, package in ipairs(require("plugins.mason").opts.ensure_installed) do
      mason[package] = true
    end
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
    for _, server in ipairs(enabled) do
      assert(mason[names[server]], "LSP package missing from Mason: " .. server)
    end
    local lint_map = { golangcilint = "golangci-lint" }
    local lint_config = require("configs.plugins.lint")
    local lint_stub = { linters_by_ft = {}, linters = { pylint = {} }, try_lint = function() end }
    T.with_modules({
      lint = lint_stub,
      ["utils.python_env"] = {
        pylint_command = function()
          return "pylint"
        end,
      },
    }, function()
      T.stub(vim.api, "nvim_create_autocmd", function() end)
      lint_config.setup()
    end)
    for _, linters in pairs(lint_stub.linters_by_ft) do
      for _, linter in ipairs(linters) do
        assert(mason[lint_map[linter] or linter], "linter package missing from Mason: " .. linter)
      end
    end
  end
end)

T.test("custom LSP files, disabled plugins and Mason tool lists are consistent", function()
  local enabled, seen = {}, {}
  T.stub(vim.lsp, "config", function() end)
  T.stub(vim.lsp, "enable", function(servers)
    enabled = servers
  end)
  do
    T.with_modules({
      ["nvchad.configs.lspconfig"] = { defaults = function() end },
      ["blink.cmp"] = {
        get_lsp_capabilities = function()
          return {}
        end,
      },
    }, function()
      require("configs.plugins.lspconfig").setup()
    end)
    for _, name in ipairs(enabled) do
      seen[name] = true
    end
    for _, path in ipairs(vim.fn.glob("lsp/*.lua", false, true)) do
      local server = vim.fn.fnamemodify(path, ":t:r")
      assert(seen[server], "custom LSP config has no enabled server: " .. server)
    end
    local disabled = require("plugins.disabled")
    for _, spec in ipairs(disabled) do
      assert(spec.enabled == false, "disabled plugin lacks enabled = false")
    end
    local tools = {}
    for _, tool in ipairs(require("plugins.mason").opts.ensure_installed) do
      assert(not tools[tool], "duplicate Mason package: " .. tool)
      tools[tool] = true
    end
  end
end)

T.test("enabled LSP servers match the expected set", function()
  local enabled
  T.stub(vim.lsp, "config", function() end)
  T.stub(vim.lsp, "enable", function(servers)
    enabled = servers
  end)
  T.with_modules({
    ["nvchad.configs.lspconfig"] = { defaults = function() end },
    ["blink.cmp"] = {
      get_lsp_capabilities = function()
        return {}
      end,
    },
  }, function()
    require("configs.plugins.lspconfig").setup()
  end)

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
  local lint = { linters_by_ft = {}, linters = { pylint = {} }, try_lint = function() end }
  T.with_modules({
    lint = lint,
    ["utils.python_env"] = {
      pylint_command = function()
        return "pylint"
      end,
    },
  }, function()
    T.stub(vim.api, "nvim_create_autocmd", function() end)
    require("configs.plugins.lint").setup()
  end)

  T.eq(lint.linters_by_ft, {
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

T.test("every enabled plugin and dependency has an entry in lazy-lock.json", function()
  local lock = vim.json.decode(table.concat(vim.fn.readfile("lazy-lock.json"), "\n"))
  local missing = {}

  local function check(plugin)
    local repo = type(plugin) == "table" and plugin[1] or plugin
    local name = type(plugin) == "table" and plugin.name or repo:gsub("^.*/", "")
    if not lock[name] then
      missing[#missing + 1] = repo
    end
  end

  for _, path in ipairs(vim.fn.glob("lua/plugins/*.lua", false, true)) do
    local result = dofile(path)
    local specs = type(result[1]) == "string" and { result } or result
    for _, spec in ipairs(specs) do
      if spec.enabled ~= false then
        check(spec)
        local dependencies = spec.dependencies
        for _, dependency in
          ipairs(type(dependencies) == "string" and { dependencies } or dependencies or {})
        do
          check(dependency)
        end
      end
    end
  end

  table.sort(missing)
  assert(
    #missing == 0,
    "plugins missing from lazy-lock.json (run :Lazy sync and commit it): "
      .. table.concat(missing, ", ")
  )
end)
