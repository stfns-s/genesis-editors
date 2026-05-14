" Vim syntax file
" Language: genesispy Python template (.vpy / .svpy / .gvpy / .vpyh)
" Version: 0.3.0
" Mirrors syntax/genesis2.vim with @pythonTop in place of @perlTop,
" plus two refinements: escape-aware backticks and Verilog-directive exclusion.
" Also covers --j2 statement and comment delimiters ({% ... %}, {# ... #})
" since the engine is per-run and the same source file can be elaborated either
" way. The `{{ ... }}` expression form is intentionally NOT highlighted -- it
" collides with Verilog brace patterns (nested concatenation, replication
" closes); leaving it as plain Verilog avoids false regions in non-j2
" sources.

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Base: SystemVerilog if available, else plain Verilog.
if !empty(globpath(&runtimepath, 'syntax/verilog_systemverilog.vim'))
    ru! syntax/verilog_systemverilog.vim
    set ft=verilog_systemverilog
else
    ru! syntax/verilog.vim
    set ft=verilog
endif
unlet! b:current_syntax

" Embedded Python.
syn include @pythonTop syntax/python.vim

" //; # <sentinel> -- block-closing sentinels (`# endif`, `# endfor`,
" `# endwhile`, and their `end if` / `end for` / `end while` spellings).
" Only the recognized keywords match; other `//; # ...` lines fall through
" to the embedded-Python region below. The line splits into three colors:
" `//;` -> `genesispyDelim`, ` # ` -> Comment (via `genesispySentinel`),
" `endX` -> magenta (via `genesispySentinelKw`).
syn region genesispySentinel matchgroup=genesispyDelim
    \ start=+//;\(\s*#\s*end\s*\(if\|for\|while\)\s*$\)\@=+
    \ end=+$+
    \ keepend oneline containedin=ALL
    \ contains=genesispySentinelKw
syn match genesispySentinelKw +end\s*\(if\|for\|while\)+ contained

" //;<rest> -- the rest of the line is Python (excluding the sentinel form
" above, which is matched separately).
syn region genesispyLine matchgroup=genesispyDelim
    \ start=+//;\(\s*#\s*end\s*\(if\|for\|while\)\s*$\)\@!+ end=+$+
    \ keepend containedin=ALL contains=@pythonTop

" `expr` -- inline Python expression.
"   * \\\@<! is "not preceded by a backslash" so the gvpy literal-backtick
"     escape (\`) does not open or close the region.
"   * \@! after the start backtick excludes the Verilog `directive keywords
"     so they are not mis-parsed as opening a Python region.
syn region genesispyInline matchgroup=genesispyDelim
    \ start=#\\\@<!`\(timescale\|default_nettype\|include\|ifdef\|if\|ifndef\|else\|endif\)\@!#
    \ end=#\\\@<!`#
    \ keepend containedin=ALL contains=@pythonTop oneline

" --j2 delimiters. Whitespace modifiers `{%-`, `-%}` are accepted
" as a syntactic no-op. Either form may span multiple physical lines,
" so no `oneline`.
"
" Sentinel form: `{% # endfor %}` and friends -- only the recognized
" block-close keywords match; other `{% # ... %}` falls through to the
" generic statement region below. Three-color split mirrors the `//;`
" sentinel above: `{%` / `%}` -> delim, ` # ` -> Comment, `endX` -> magenta.
syn region genesispyJ2Sentinel matchgroup=genesispyDelim
    \ start=+{%-\?\(\s*#\s*end\s*\(if\|for\|while\)\s*-\?%}\)\@=+
    \ end=+-\?%}+
    \ keepend oneline containedin=ALL
    \ contains=genesispySentinelKw

" {% python stmt %} -- excludes the sentinel form above.
syn region genesispyJ2Stmt matchgroup=genesispyDelim
    \ start=+{%-\?\(\s*#\s*end\s*\(if\|for\|while\)\s*-\?%}\)\@!+ end=+-\?%}+
    \ keepend containedin=ALL contains=@pythonTop

" {# template comment #} -- stripped at elaboration; pure comment.
syn region genesispyJ2Comment matchgroup=genesispyDelim
    \ start=+{#+ end=+#}+ keepend containedin=ALL

hi link genesispyJ2Comment Comment
hi link genesispyDelim PreProc

" Make embedded Python visually distinct from Verilog (which uses Statement).
hi genesispyPyKeyword  cterm=bold gui=bold ctermfg=magenta guifg=magenta
hi genesispyPyBuiltin  cterm=bold gui=bold
hi genesispyPyFunction cterm=bold gui=bold
hi link pythonStatement   genesispyPyKeyword
hi link pythonConditional genesispyPyKeyword
hi link pythonRepeat      genesispyPyKeyword
hi link pythonOperator    genesispyPyKeyword
hi link pythonException   genesispyPyKeyword
hi link pythonInclude     genesispyPyKeyword
hi link pythonBuiltin     genesispyPyBuiltin
hi link pythonFunction    genesispyPyFunction
hi link pythonDecorator   genesispyPyKeyword

" Sentinel body (`#`, surrounding whitespace, and the `endX` keyword) is
" all bold magenta; only the surrounding `//;` / `{%` / `%}` delimiters
" keep their delim color.
hi genesispySentinel cterm=bold gui=bold ctermfg=magenta guifg=magenta
hi link genesispyJ2Sentinel  genesispySentinel
hi link genesispySentinelKw  genesispySentinel

let b:current_syntax = "genesispy"

" vim: set ts=4 sw=4:
