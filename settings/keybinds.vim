" Remove highlights on esc
nnoremap <silent><esc> :noh<CR>

" Re-source VIMRC
nnoremap <leader>sv :source $MYVIMRC<CR>

" Open Fern over pane and reveal current file
nnoremap <silent><leader>d :Fern . -reveal=%<CR>

" Open FZF
nnoremap <leader>ff :Files<CR>

" Run tests
nnoremap <leader>vt :TestFile<CR>
nnoremap <leader>vtn :TestNearest<CR>
nnoremap <leader>vta :TestSuite<CR>

if (has("nvim"))
  lua << EOF
  local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF
  nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
  vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
endif

nnoremap <silent><C-h> :FocusSplitLeft<CR>
nnoremap <silent><C-l> :FocusSplitRight<CR>
nnoremap <silent><C-j> :FocusSplitDown<CR>

nnoremap <silent><Space> :Telescope command_palette<CR>

nnoremap <silent><leader>p :LspHover<CR>
