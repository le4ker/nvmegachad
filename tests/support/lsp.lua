local T = require("test_helper")

local M = {}

-- Runs configs.plugins.lspconfig.setup() with NvChad, Blink and the vim.lsp API stubbed, and
-- returns what it did: the enabled servers, the vim.lsp.config calls and the defaults() count.
function M.setup_lspconfig(capabilities)
  capabilities = capabilities or {}
  local result = { enabled = nil, config_calls = {}, default_calls = 0 }

  T.stub(vim.lsp, "config", function(name, opts)
    result.config_calls[#result.config_calls + 1] = { name = name, opts = opts }
  end)
  T.stub(vim.lsp, "enable", function(servers)
    result.enabled = servers
  end)
  T.with_modules({
    ["nvchad.configs.lspconfig"] = {
      defaults = function()
        result.default_calls = result.default_calls + 1
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

  return result
end

return M
