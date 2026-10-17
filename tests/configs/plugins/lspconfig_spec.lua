local T = require("test_helper")
local setup_lspconfig = require("support.lsp").setup_lspconfig

T.test("LSP setup loads NvChad defaults, Blink capabilities, and the configured servers", function()
  local capabilities = { completion = true }
  local result = setup_lspconfig(capabilities)

  T.eq(result.default_calls, 1)
  T.eq(result.config_calls[1].name, "*")
  T.eq(result.config_calls[1].opts.capabilities, capabilities)
  T.eq(type(result.enabled), "table")
  assert(#result.enabled > 0, "no LSP servers enabled")
  local seen = {}
  for _, server in ipairs(result.enabled) do
    assert(not seen[server], "duplicate enabled LSP server: " .. server)
    seen[server] = true
  end
end)
