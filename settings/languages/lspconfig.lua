local lspconfig = require('lspconfig')
local null_ls = require("null-ls")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
        noremap=true,
    })
end

local on_attach = function(client, bufnr)
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
  vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map(bufnr, 'n', '<C-p>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_map(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_map(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_map(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_map(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_map(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map(bufnr, 'n', '<C-a>', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  buf_map(bufnr, 'n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<CR>')
  buf_map(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  buf_map(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  buf_map(bufnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  buf_map(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

  if client.server_capabilities.document_formatting then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end

end

lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
      local ts_utils = require("nvim-lsp-ts-utils")
      ts_utils.setup({})
      ts_utils.setup_client(client)
      buf_map(bufnr, "n", "<C-n>", ":TSLspOrganize<CR>")
      buf_map(bufnr, "n", "<C-r>", ":TSLspRenameFile<CR>")
      buf_map(bufnr, "n", "<C-i>", ":TSLspImportAll<CR>")

      on_attach(client, bufnr)
  end,
  flags = {
    debounce_text_changes = 150,
  }
}

require('lspsaga').init_lsp_saga()
