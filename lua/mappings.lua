local map = vim.keymap.set

-- General
map("i", "<C-h>", "<Left>", { desc = "General Move Left" })
map("i", "<C-l>", "<Right>", { desc = "General Move Right" })
map("i", "<C-j>", "<Down>", { desc = "General Move Down" })
map("i", "<C-k>", "<Up>", { desc = "General Move Up" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear Highlights", silent = true })
map("n", "<C-h>", "<C-w>h", { desc = "General Switch Window Left" })
map("n", "<C-l>", "<C-w>l", { desc = "General Switch Window Right" })
map("n", "<C-j>", "<C-w>j", { desc = "General Switch Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "General Switch Window Up" })
map("n", "<leader>y", "<cmd>%y+<CR>", { desc = "General Copy Whole File", silent = true })
map("n", "<S-u>", "<C-r>", { desc = "General Redo" })
map("n", "<C-d>", "<C-d>zz", { desc = "General Move Half Page Down And Center" })
map("n", "<C-u>", "<C-u>zz", { desc = "General Move Half Page Up And Center" })
map("n", "<C-f>", "<C-f>zz", { desc = "General Move Full Page Down And Center" })
map("n", "<C-b>", "<C-b>zz", { desc = "General Move Full Page Up And Center" })
map("n", "<leader>s", "<cmd>w<CR>", { desc = "General Save File", silent = true })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "General Quit", silent = true })
map("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "General Vertical Split", silent = true })
map("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "General Update Lazy Plugins", silent = true })
map("n", "<leader>mu", function()
  vim.notify("Updating Mason packages...", vim.log.levels.INFO)
  local registry = require "mason-registry"
  registry.refresh(function()
    local installed = registry.get_installed_packages()
    for _, pkg in ipairs(installed) do
      pkg:install()
    end
    vim.schedule(function()
      vim.cmd "Mason"
    end)
  end)
end, { desc = "General Update Mason Packages", silent = true })
map("n", "<leader>pr", "<cmd>MarkdownPreviewToggle<CR>", { desc = "General Preview Markdown File", silent = true })
map("n", "<leader>tf", function()
  vim.g.format_on_save = not vim.g.format_on_save
  vim.notify(vim.g.format_on_save and "Format on save enabled" or "Format on save disabled")
end, { desc = "General Toggle Format On Save" })
map("n", "<leader>tn", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "General Toggle Relative Numbers" })
map("n", "<leader>ti", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "General Toggle Inlay Hints" })
map("n", "<leader>/", "gcc", { desc = "General Toggle Comment", remap = true })
map("v", "<leader>/", "gc", { desc = "General Toggle Comment", remap = true })
-- Tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "Buffer New", silent = true })
map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Buffer Go To Next" })
map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Buffer Go To Previous" })
map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer Close" })

map({ "i", "s" }, "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  elseif vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
    return ""
  else
    return "<S-Tab>"
  end
end, { expr = true, silent = true, desc = "General Previous Completion" })

-- NvimTree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer Toggle", silent = true })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Explorer Focus", silent = true })

-- Telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Search Live grep", silent = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Search Buffers", silent = true })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Search Git Commits", silent = true })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Search Git Status", silent = true })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Search Hidden Terminals", silent = true })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Search Files", silent = true })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "Search All Files", silent = true }
)

-- Terminal
local function close_terminal()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == "terminal" then
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_close(win, true)
  end
end
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp", size = 0.5 }
end, { desc = "Terminal New Horizontal Terminal" })
map("n", "<ESC><ESC>", close_terminal, { desc = "Terminal Close Terminal" })
map("t", "<ESC><ESC>", close_terminal, { desc = "Terminal Close Terminal" })

-- NvChad
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "NvChad Toggle NvCheatsheet", silent = true })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "NvChad Show Themes", silent = true })

-- LSP
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP Go To Declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP Go To Definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Go To Implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "[d", function()
  vim.diagnostic.jump { count = -1 }
end, { desc = "LSP Go To Previous Diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump { count = 1 }
end, { desc = "LSP Go To Next Diagnostic" })

-- DAP
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "DAP Add Breakpoint At Line", silent = true })
map("n", "<leader>dn", "<cmd>DapStepOver<CR>", { desc = "DAP Step Over", silent = true })
map("n", "<leader>di", "<cmd>DapStepIn<CR>", { desc = "DAP Step In", silent = true })
map("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "DAP Continue", silent = true })
map("n", "<leader>dt", "<cmd>DapTerminate<CR>", { desc = "DAP Terminate", silent = true })
map("n", "<leader>do", "<cmd>DapStepOut<CR>", { desc = "DAP Step Out", silent = true })
map("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "DAP Debug Go Test" })
map("n", "<leader>dgl", function()
  require("dap-go").debug_last_test()
end, { desc = "DAP Debug Last Go Test" })
map("n", "<leader>dpt", function()
  require("dap-python").test_method()
end, { desc = "DAP Debug Python Test" })
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "DAP Toggle UI" })

-- CodeCompanion
map("n", "<leader>cc", "<cmd>CodeCompanionChat<CR>", { desc = "AI Open Chat", silent = true })
map("n", "<leader>cct", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "AI Toggle Chat", silent = true })
map("n", "<leader>cca", "<cmd>CodeCompanionActions<CR>", { desc = "AI Actions", silent = true })
map("v", "<leader>cc", "<cmd>CodeCompanionChat<CR>", { desc = "AI Chat With Selection", silent = true })

local cc_zoomed = false
map("n", "<leader>ccz", function()
  vim.cmd(cc_zoomed and "wincmd =" or "wincmd |")
  cc_zoomed = not cc_zoomed
end, { desc = "AI Zoom Chat Window" })
