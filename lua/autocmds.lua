-- Open the file tree on startup without taking focus from the current buffer.

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open file tree on startup",
  callback = function()
    require("nvim-tree.api").tree.open({ focus = false })
  end,
})
