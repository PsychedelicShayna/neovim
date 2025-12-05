" When this autocdmd is  triggered in ftdetect, set comment string for local
" buffeer.
" augroup ftdetect_sto
"   autocmd! BufRead,BufNewFile *.bind setfiletype sto
" augroup END
"
" When triggered set comments for Star Trek Online keybind files
"
"

augroup filetype_sto
  autocmd!
  autocmd FileType sto setlocal commentstring=#\ %s
augroup END
