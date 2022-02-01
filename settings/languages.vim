if (has("nvim"))
  lua << EOF
local lspconfig = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-p>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end


-- lspconfig.efm.setup {
--     root_dir = lspconfig.util.root_pattern("yarn.lock", "package-lock.json", "lerna.json", ".git"),
--     init_options = {documentFormatting = true, codeAction = true},
--     settings = {languages = languages, log_level = 1, log_file = '~/efm.log'},
--     on_attach = on_attach
-- }
lspconfig.efm.setup {
    init_options = {documentFormatting = true},
    settings = {
      rootMarkers = {".git/"},
    },
    filetypes = { 'javascript' }
}

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
