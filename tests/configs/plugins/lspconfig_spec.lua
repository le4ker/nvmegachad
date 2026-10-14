local T = require("test_helper")

T.test("LSP setup loads NvChad defaults, Blink capabilities, and the configured servers", function()
  local original_config, original_enable = vim.lsp.config, vim.lsp.enable
  local default_calls, config_calls, enabled = 0, {}, nil
  local capabilities = { completion = true }

  vim.lsp.config = function(name, opts)
    config_calls[#config_calls + 1] = { name = name, opts = opts }
  end
  vim.lsp.enable = function(servers)
    enabled = servers
  end

  local ok, err = pcall(function()
    T.with_modules({
      ["nvchad.configs.lspconfig"] = {
        defaults = function()
          default_calls = default_calls + 1
        end,
      },
      ["blink.cmp"] = {
        get_lsp_capabilities = function()
          return capabilities
        end,
      },
    }, function()
      require("configs.plugins.lspconfig").setup()
    end)

    T.eq(default_calls, 1)
    T.eq(config_calls[1].name, "*")
    T.eq(config_calls[1].opts.capabilities, capabilities)
    T.eq(
      table.concat(enabled, ","),
      "bashls,clangd,cssls,dockerls,gopls,html,jsonls,lua_ls,marksman,pyright,ruby_lsp,taplo,terraformls,ts_ls,vimls,yamlls"
    )
  end)

  vim.lsp.config, vim.lsp.enable = original_config, original_enable
  assert(ok, err)
end)

T.test("Pyright config uses a project Python when one is detected", function()
  local python_path = "/workspace/.venv/bin/python"
  T.with_modules({
    ["utils.python_env"] = {
      python_path = function(root, is_directory)
        T.eq(root, "/workspace")
        T.eq(is_directory, true)
        return python_path
      end,
    },
  }, function()
    local config = dofile("lsp/pyright.lua")
    local server_config = { root_dir = "/workspace", settings = vim.deepcopy(config.settings) }
    config.before_init(nil, server_config)
    T.eq(server_config.settings.python.pythonPath, python_path)
    T.eq(server_config.settings.python.analysis.diagnosticMode, "workspace")
  end)
end)

T.test(
  "Pyright config leaves its Python path unchanged when no project interpreter is found",
  function()
    T.with_modules({
      ["utils.python_env"] = {
        python_path = function()
          return nil
        end,
      },
    }, function()
      local config = dofile("lsp/pyright.lua")
      local server_config = { root_dir = "/workspace", settings = vim.deepcopy(config.settings) }
      server_config.settings.python.pythonPath = "/system/python"
      config.before_init(nil, server_config)
      T.eq(server_config.settings.python.pythonPath, "/system/python")
    end)
  end
)

T.test("gopls config enables expected analysis and inlay hints", function()
  local settings = dofile("lsp/gopls.lua").settings.gopls
  T.eq(settings.completeUnimported, true)
  T.eq(settings.analyses.unusedparams, true)
  T.eq(settings.hints.assignVariableTypes, true)
  T.eq(settings.hints.rangeVariableTypes, true)
end)
