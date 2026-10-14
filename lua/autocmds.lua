require("nvchad.autocmds")

-- Open the file tree on startup without taking focus from the current buffer.

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open file tree on startup",
  callback = function()
    local api = require("nvim-tree.api")

    if not api.tree.is_visible() then
      api.tree.toggle({ focus = false })
    end
  end,
})
