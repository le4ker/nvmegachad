return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require("telescope.actions")
    local close_mapping = { ["<Esc><Esc>"] = actions.close }

    return vim.tbl_deep_extend("force", opts, {
      defaults = {
        mappings = {
          i = close_mapping,
          n = close_mapping,
        },
      },
    })
  end,
}
