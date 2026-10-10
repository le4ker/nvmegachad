return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function()
    require("configs.plugins.lspconfig").setup()
  end,
}
