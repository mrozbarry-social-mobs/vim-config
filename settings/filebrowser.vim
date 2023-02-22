" Fern
let g:fern#renderer = "nerdfont"
let g:fern#default_hidden = 1

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
