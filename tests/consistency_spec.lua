local T = require("test_helper")

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
