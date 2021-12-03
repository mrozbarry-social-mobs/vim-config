" Plugins
call plug#begin(stdpath('data') . '/plugged')

for f in split(glob('~/vim-config/plugins/*.vim'), '\n')
  exe 'source' f
endfor

call plug#end()

" Settings
for f in split(glob('~/vim-config/settings/*.vim'), '\n')
  exe 'source' f
endfor
