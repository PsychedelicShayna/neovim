" Place this at: ~/.config/nvim/ftdetect/sto.vim
" Detect common Star Trek Online keybind filenames (adjust glob as you prefer)
augroup ftdetect_sto
  autocmd! BufRead,BufNewFile *.bind setfiletype sto
augroup END
