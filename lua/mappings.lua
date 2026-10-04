local map = vim.keymap.set
local actions = require("utils.mapping_actions")

-- General
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear Highlights", silent = true })
map("n", "<C-h>", "<C-w>h", { desc = "General Switch Window Left" })
map("n", "<C-j>", "<C-w>j", { desc = "General Switch Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "General Switch Window Up" })
map("n", "<C-l>", "<C-w>l", { desc = "General Switch Window Right" })
map("n", "<S-u>", "<C-r>", { desc = "General Redo" })
map("n", "<C-d>", "<C-d>zz", { desc = "General Move Half Page Down And Center" })
map("n", "<C-u>", "<C-u>zz", { desc = "General Move Half Page Up And Center" })
map("n", "<leader>s", "<cmd>w<CR>", { desc = "General Save File", silent = true })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "General Quit", silent = true })
map("n", "<leader>y", "<cmd>%y+<CR>", { desc = "General Copy Whole File", silent = true })
map("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "General Vertical Split", silent = true })
map("n", "<leader>pr", "<cmd>MarkdownPreviewToggle<CR>", {
  desc = "General Preview Markdown File",
  silent = true,
})
map(
  "n",
  "<leader>lu",
  "<cmd>Lazy update<CR>",
  { desc = "General Update Lazy Plugins", silent = true }
)
map("n", "<leader>/", "gcc", { desc = "General Toggle Comment", remap = true })
map("v", "<leader>/", "gc", { desc = "General Toggle Comment", remap = true })
map("n", "<leader>mu", actions.update_mason_packages, { desc = "General Update Mason Packages" })

map("n", "<leader>tf", actions.toggle_format_on_save, { desc = "General Toggle Format On Save" })
map("n", "<leader>ti", actions.toggle_inlay_hints, { desc = "General Toggle Inlay Hints" })

-- Buffer Management
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "Buffer New", silent = true })
map("n", "<tab>", actions.next_buffer, { desc = "Buffer Go To Next" })
map("n", "<S-tab>", actions.previous_buffer, { desc = "Buffer Go To Previous" })
map("n", "<leader>x", actions.close_buffer, { desc = "Buffer Close" })

-- File Explorer
-- Use a nonbreaking space so NvChad keeps "File Explorer" together as one cheatsheet heading.
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "File Explorer Focus", silent = true })
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "File Explorer Toggle", silent = true })

-- Search
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Search Files", silent = true })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Search Live grep", silent = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Search Buffers", silent = true })
map(
  "n",
  "<leader>cm",
  "<cmd>Telescope git_commits<CR>",
  { desc = "Search Git Commits", silent = true }
)
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", {
  desc = "Search Git Status",
  silent = true,
})
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Search Terminals", silent = true })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", {
  desc = "Search All Files",
  silent = true,
})

-- Terminal
map("n", "<leader>h", actions.new_horizontal_terminal, {
  desc = "Terminal New Horizontal Terminal",
})
map("n", "<ESC><ESC>", actions.close_terminal, { desc = "Terminal Close Terminal" })
map("t", "<ESC><ESC>", actions.close_terminal, { desc = "Terminal Close Terminal" })

-- NvChad
map(
  "n",
  "<leader>ch",
  "<cmd>NvCheatsheet<CR>",
  { desc = "NvChad Toggle NvCheatsheet", silent = true }
)
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "NvChad Show Themes", silent = true })

-- LSP
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP Go To Declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP Go To Definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Go To Implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "[d", actions.previous_diagnostic, { desc = "LSP Go To Previous Diagnostic" })
map("n", "]d", actions.next_diagnostic, { desc = "LSP Go To Next Diagnostic" })

-- DAP
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", {
  desc = "DAP Add Breakpoint At Line",
  silent = true,
})
map("n", "<leader>dn", "<cmd>DapStepOver<CR>", { desc = "DAP Step Over", silent = true })
map("n", "<leader>di", "<cmd>DapStepIn<CR>", { desc = "DAP Step In", silent = true })
map("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "DAP Continue", silent = true })
map("n", "<leader>dt", "<cmd>DapTerminate<CR>", { desc = "DAP Terminate", silent = true })
map("n", "<leader>do", "<cmd>DapStepOut<CR>", { desc = "DAP Step Out", silent = true })
map("n", "<leader>dgt", actions.debug_go_test, { desc = "DAP Debug Go Test" })
map("n", "<leader>dgl", actions.debug_last_go_test, { desc = "DAP Debug Last Go Test" })
map("n", "<leader>dpt", actions.debug_python_test, { desc = "DAP Debug Python Test" })
map("n", "<leader>du", actions.toggle_dap_ui, { desc = "DAP Toggle UI" })

-- AI
map("n", "<leader>cc", "<cmd>CodeCompanionChat<CR>", { desc = "AI Open Chat", silent = true })
map("n", "<leader>cct", "<cmd>CodeCompanionChat Toggle<CR>", {
  desc = "AI Toggle Chat",
  silent = true,
})
map("n", "<leader>cca", "<cmd>CodeCompanionActions<CR>", { desc = "AI Actions", silent = true })
map(
  "v",
  "<leader>cc",
  "<cmd>CodeCompanionChat<CR>",
  { desc = "AI Chat With Selection", silent = true }
)
map("n", "<leader>ccz", actions.toggle_chat_zoom, { desc = "AI Zoom Chat Window" })
