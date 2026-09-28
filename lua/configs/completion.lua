-- Native LSP completion (Neovim 0.11+)

vim.opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
  "popup",
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("NativeLspCompletion", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end
  end,
})
