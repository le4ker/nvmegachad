return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  config = function()
    require("configs.plugins.treesitter").setup()
  end,
}
