require("nvchad.configs.lspconfig").defaults()

local servers = {
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

vim.lsp.inlay_hint.enable(true)

-- merge blink.cmp's expanded capabilities into every server
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Override nvim-lspconfig's Pyright default, which limits diagnostics to open files.
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

vim.lsp.enable(servers)
