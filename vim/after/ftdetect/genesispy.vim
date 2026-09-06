" Version: 0.3.1
" Use `set filetype=` (force) and run from after/ftdetect so we win against
" any plugin whose ftdetect claims these extensions and uses `au!` to clear
" earlier autocmds.
au! BufRead,BufNewFile *.vpy  set filetype=genesispy
au! BufRead,BufNewFile *.svpy set filetype=genesispy
au! BufRead,BufNewFile *.gvpy set filetype=genesispy
au! BufRead,BufNewFile *.vpyh set filetype=genesispy
