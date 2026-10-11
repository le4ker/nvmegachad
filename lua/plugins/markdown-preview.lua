return {
  "selimacerbas/mdkite.nvim",
  dependencies = { "selimacerbas/kitehost.nvim" },
  ft = { "markdown" },
  config = function()
    require("mdkite").setup({})
  end,
}
