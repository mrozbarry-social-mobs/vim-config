#!/bin/sh

# See https://github.com/junegunn/vim-plug#installation for details
curl -fLo ~/.vim/autoload/plug.vim \
  --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
