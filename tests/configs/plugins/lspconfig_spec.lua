local T = require("test_helper")

T.test("LSP setup loads NvChad defaults, Blink capabilities, and the configured servers", function()
  local default_calls, config_calls, enabled = 0, {}, nil
  local capabilities = { completion = true }

  T.stub(vim.lsp, "config", function(name, opts)
    config_calls[#config_calls + 1] = { name = name, opts = opts }
  end)
  T.stub(vim.lsp, "enable", function(servers)
    enabled = servers
  end)

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
  T.eq(type(enabled), "table")
  assert(#enabled > 0, "no LSP servers enabled")
  local seen = {}
  for _, server in ipairs(enabled) do
    assert(not seen[server], "duplicate enabled LSP server: " .. server)
    seen[server] = true
  end
end)
