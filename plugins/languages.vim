" Many language highlighting plugins
Plug 'sheerun/vim-polyglot'

" Language server support via neovim
if has("nvim")
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'folke/lsp-colors.nvim'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  Plug 'ms-jpq/coq.artifacts'
  Plug 'ms-jpq/coq.thirdparty'
  Plug 'glepnir/lspsaga.nvim'
else
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
endif



