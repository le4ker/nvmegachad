vim.opt.rtp:prepend(vim.fn.getcwd())
package.path = "./lua/?.lua;./lua/?/init.lua;./tests/?.lua;" .. package.path

require("utils.formatter_spec")
require("actions.mapping_actions_spec")
require("configs.plugins.mason_spec")
require("configs.plugins.lspconfig_spec")
require("configs.plugins.dap_spec")
require("configs.plugins.dap_ui_spec")
require("plugins.conform_spec")
require("plugins.dap_spec")
require("mappings_spec")
require("startup_spec")
require("utils.python_env_spec")

require("test_helper").run()
