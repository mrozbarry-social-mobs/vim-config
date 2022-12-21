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

  for f in split(glob('~/vim-config/settings/languages/*.lua'), '\n')
    exe 'source' f
  endfor

  nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
  vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>

  au BufWritePost lua require('lint').try_lint()

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
