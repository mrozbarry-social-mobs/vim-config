# Upgrade your vim/neovim with vim-plug

## Instructions

 1. Clone this repo into home directory: `cd ~ && git clone git@github.com:mrozbarry-social-mobs/vim-config.git`
 2. Run setup (also chmod +x on files)
    - For neovim: `./setup.nvim.sh`
    - For vim: `./setup.vim.sh`
 3. Source in your default config file
    - For neovim: `~/.config/nvim/init.vim` should contain `source ~/vim-config/init.vim`
    - For vim: `~/.vimrc` should contain `source ~/vim-config/vimrc`

## Goals

 - [x] Configure loaders for plugin files and settings
 - [x] Set up the leader key (using `,`)
 - [x] Make it easier to reload the config
 - [x] Install a file browser
 - [ ] Configure a theme
 - [ ] Upgrade status bar
 - [ ] Language server support (neovim only?)
   - neovim: https://github.com/neovim/nvim-lspconfig + https://github.com/williamboman/nvim-lsp-installer
   - vim: https://github.com/dense-analysis/ale (may require global npm installs for linting to work)
 - [ ] ...others?

## Notes for key mapping


{keymap type}map {key sequence} {command}

Where `keymap` can be combined from:

Type:
 - `n` for normal mode
 - `v` for select/visual mode
 - `i` for insert mode

Optional:
 - `nore` for "no recursion", likely meaning don't try to use other keymaps with this

Suffix:
 - `map`

Key `sequence` can be combined from:
 - alpha-numeric
 - <CR> for carriage return
 - <F#> for F# keys
 - <leader> for leader key

And `command` is anything that can be typed in normal mode. Typically these will start with `:` and end in `<CR>`. You can chain multiple together, separated by `<CR>`.

Examples:

 - `nnoremap <leader>d :Fern . -reveal=%<CR>` to open fern and reveal the path to the current opened file
