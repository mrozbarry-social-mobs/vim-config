let mapleader = ","

set tabstop=2
set shiftwidth=2
set expandtab
set nowrap
set number
set nobackup
set nowritebackup

syntax on
set t_Co=256
if has("nvim")
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if has("termguicolors")
  set termguicolors
endif

set background=dark
" colorscheme challenger_deep
colorscheme purify
