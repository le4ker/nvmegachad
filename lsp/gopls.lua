-- Disable insertReplaceSupport to fix completion error with gopls
-- See: https://github.com/neovim/neovim/issues/30332
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

return {
  capabilities = capabilities,
  settings = {
    gopls = {
      completeUnimported = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}
