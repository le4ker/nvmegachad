local T = require("test_helper")

T.test("options set the expected Neovim defaults and format-on-save toggle", function()
  local saved = {
    backup = vim.opt.backup:get(),
    swapfile = vim.opt.swapfile:get(),
    undofile = vim.opt.undofile:get(),
    colorcolumn = vim.opt.colorcolumn:get(),
    relativenumber = vim.opt.relativenumber:get(),
    list = vim.opt.list:get(),
    listchars = vim.opt.listchars:get(),
    completeopt = vim.opt.completeopt:get(),
  }
  T.cleanup(function()
    for name, value in pairs(saved) do
      vim.opt[name] = value
    end
  end)
  T.stub(vim.g, "format_on_save", vim.g.format_on_save)
  T.with_modules({ ["nvchad.options"] = true }, function()
    dofile("lua/options.lua")
  end)
  T.eq(vim.g.format_on_save, true)
  T.eq(tostring(vim.opt.backup:get()), "false")
  T.eq(tostring(vim.opt.swapfile:get()), "false")
  T.eq(tostring(vim.opt.undofile:get()), "true")
  T.eq(vim.opt.colorcolumn:get()[1], "100")
  T.eq(vim.opt.relativenumber:get(), true)
  T.eq(vim.opt.list:get(), true)
  T.eq(vim.opt.listchars:get().tab, "➝ ")
  T.eq(vim.opt.listchars:get().space, "·")
end)
