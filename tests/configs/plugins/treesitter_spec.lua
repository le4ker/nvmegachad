local T = require("test_helper")

T.test("treesitter installs parsers and starts highlighting on FileType", function()
  local setup_opts, installed, autocmd, started
  T.with_modules({
    ["nvim-treesitter"] = {
      setup = function(opts)
        setup_opts = opts
      end,
      install = function(parsers)
        installed = parsers
      end,
    },
  }, function()
    T.stub(vim.api, "nvim_create_autocmd", function(event, opts)
      autocmd = { event, opts }
    end)
    T.stub(vim.treesitter, "start", function(buf, lang)
      started = { buf, lang }
    end)
    require("configs.plugins.treesitter").setup()
  end)
  T.eq(type(setup_opts), "table")
  T.eq(type(installed), "table")
  assert(#installed > 0, "Tree-sitter parser list is empty")
  local seen = {}
  for _, parser in ipairs(installed) do
    assert(not seen[parser], "duplicate Tree-sitter parser: " .. parser)
    seen[parser] = true
  end
  T.eq(autocmd[1], "FileType")
  autocmd[2].callback({ buf = 17, match = "lua" })
  T.eq(table.concat(started, ","), "17,lua")
end)

T.test("treesitter FileType callback ignores filetypes without a parser", function()
  local callback
  T.with_modules({
    ["nvim-treesitter"] = { setup = function() end, install = function() end },
  }, function()
    T.stub(vim.api, "nvim_create_autocmd", function(_, opts)
      callback = opts.callback
    end)
    require("configs.plugins.treesitter").setup()
  end)

  local buf = vim.api.nvim_create_buf(false, true)
  T.cleanup(function()
    vim.api.nvim_buf_delete(buf, { force = true })
  end)
  -- Without the pcall, opening such a file raises an error on every FileType event.
  local ok = pcall(vim.treesitter.start, buf, "no_such_parser_language")
  T.eq(ok, false, "precondition: starting Tree-sitter without a parser must fail")
  local callback_ok, err = pcall(callback, { buf = buf, match = "no_such_parser_language" })
  assert(callback_ok, "FileType callback must not raise for an unknown language: " .. tostring(err))
end)
