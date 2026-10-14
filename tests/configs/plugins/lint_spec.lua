local T = require("test_helper")

T.test("lint setup configures filetypes, Python command and buffer autocmds", function()
  local autocmds, linted = {}, 0
  T.with_modules({
    lint = {
      linters_by_ft = {},
      linters = { pylint = {} },
      try_lint = function()
        linted = linted + 1
      end,
    },
    ["utils.python_env"] = {
      pylint_command = function(path)
        T.eq(path, "/work/main.py")
        return "/venv/bin/pylint"
      end,
    },
  }, function()
    local old_create, old_name = vim.api.nvim_create_autocmd, vim.api.nvim_buf_get_name
    vim.api.nvim_create_autocmd = function(events, opts)
      autocmds[#autocmds + 1] = { events, opts }
    end
    vim.api.nvim_buf_get_name = function()
      return "/work/main.py"
    end
    local ok, err = pcall(function()
      require("configs.plugins.lint").setup()
      local lint = require("lint")
      T.eq(table.concat(lint.linters_by_ft.python, ","), "pylint")
      T.eq(lint.linters.pylint.cmd(), "/venv/bin/pylint")
      T.eq(table.concat(autocmds[1][1], ","), "BufReadPost,BufWritePost")
      autocmds[1][2].callback()
      T.eq(linted, 1)
    end)
    vim.api.nvim_create_autocmd, vim.api.nvim_buf_get_name = old_create, old_name
    assert(ok, err)
  end)
end)
