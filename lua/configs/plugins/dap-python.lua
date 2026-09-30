local path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
require("dap-python").setup(path)
