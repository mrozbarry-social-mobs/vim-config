
" Language server support via neovim
if has("nvim")
  Plug 'nvim-lua/plenary.nvim'

  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  Plug 'ms-jpq/coq.artifacts'
  Plug 'ms-jpq/coq.thirdparty'

  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'tami5/lspsaga.nvim'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

  Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

  Plug 'folke/lsp-colors.nvim'

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'mfussenegger/nvim-lint'
else
  " Many language highlighting plugins
  Plug 'sheerun/vim-polyglot'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
endif



