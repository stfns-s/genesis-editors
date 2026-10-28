" Version: 0.4.0
" Use `set filetype=` (force) and run from after/ftdetect so we win against
" any plugin whose ftdetect claims these extensions and uses `au!` to clear
" earlier autocmds.
au! BufRead,BufNewFile *.vpy  set filetype=genesispy
au! BufRead,BufNewFile *.svpy set filetype=genesispy
au! BufRead,BufNewFile *.gvpy set filetype=genesispy
au! BufRead,BufNewFile *.vpyh set filetype=genesispy
" C++ and C templates; syntax/genesispy.vim picks the base from the extension.
" Forcing also overrides Vim's own *.cpy rule (COBOL copybook or Python).
au! BufRead,BufNewFile *.cpppy  set filetype=genesispy
au! BufRead,BufNewFile *.cppgpy set filetype=genesispy
au! BufRead,BufNewFile *.cpy    set filetype=genesispy
au! BufRead,BufNewFile *.cgpy   set filetype=genesispy
