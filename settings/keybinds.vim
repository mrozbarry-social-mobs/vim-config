" Remove highlights on esc
nnoremap <esc> :noh<CR>

" Re-source VIMRC
nnoremap <leader>sv :source $MYVIMRC<CR>

" Open Fern over pane and reveal current file
nnoremap <leader>d :Fern . -reveal=%<CR>

" Open FZF
nnoremap <leader>ff :Files<CR>
