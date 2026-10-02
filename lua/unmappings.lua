local function safe_unmap(mode, key)
  pcall(vim.keymap.del, mode, key)
end

safe_unmap("i", "<C-W>")
safe_unmap("i", "<C-U>")
safe_unmap("n", "&")
safe_unmap("x", "#")
safe_unmap("x", "*")
