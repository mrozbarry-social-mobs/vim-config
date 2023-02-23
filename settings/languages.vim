if (has("nvim"))

  let g:coq_settings = {
        \   'auto_start': 'shut-up',
        \   'keymap': {
        \     'bigger_preview': '',
        \     'jump_to_mark': '',
        \     'pre_select': v:false,
        \     'recommended': v:false,
        \   }
        \ }

  ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
  ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
  ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
  ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
  ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

  lua << EOF
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

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
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

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.prettier
    },
    on_attach = on_attach
})

require('lspsaga').init_lsp_saga()

EOF
  nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
  vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>

else
  imap <c-space> <Plug>(asyncomplete_force_refresh)
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

  if executable('pyls')
      " pip install python-language-server
      au User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'allowlist': ['python'],
          \ })
  endif

  function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=yes
      if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
      nmap <buffer> gd <plug>(lsp-definition)
      nmap <buffer> gs <plug>(lsp-document-symbol-search)
      nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
      nmap <buffer> gr <plug>(lsp-references)
      nmap <buffer> gi <plug>(lsp-implementation)
      nmap <buffer> gt <plug>(lsp-type-definition)
      nmap <buffer> <leader>rn <plug>(lsp-rename)
      nmap <buffer> [g <plug>(lsp-previous-diagnostic)
      nmap <buffer> ]g <plug>(lsp-next-diagnostic)
      nmap <buffer> K <plug>(lsp-hover)
      inoremap <buffer> <expr><c-f> lsp#scroll(+4)
      inoremap <buffer> <expr><c-d> lsp#scroll(-4)

      let g:lsp_format_sync_timeout = 1000
      autocmd! BufWritePre *.js call execute('LspDocumentFormatSync')

      " refer to doc to add more commands
  endfunction

  augroup lsp_install
      au!
      " call s:on_lsp_buffer_enabled only for languages that has the server registered.
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END
endif
