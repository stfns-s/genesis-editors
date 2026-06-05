" Vim syntax file
" Language: libpy Python template (.lpy / .libpy)
" Version: 0.3.0
" Mirrors syntax/genesispy.vim with a Liberty base in place of Verilog. The
" embedded-Python schema (//; lines, //; # endX sentinels, backtick inline
" expressions, and --j2 {% ... %} / {# ... #} delimiters) is identical. The
" Verilog backtick-directive exclusion is dropped: Liberty has no backtick
" directives.

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Base: Liberty.
ru! syntax/liberty.vim
unlet! b:current_syntax

" Liberty is case-insensitive (liberty.vim sets `syn case ignore`). Reset to
" case-sensitive so embedded Python keywords match correctly. Liberty's own
" keywords are already registered above, so this does not affect them.
syn case match

" Embedded Python.
syn include @pythonTop syntax/python.vim

" //; # <sentinel> -- block-closing sentinels (`# endif`, `# endfor`,
" `# endwhile`, and their `end if` / `end for` / `end while` spellings).
" Only the recognized keywords match; other `//; # ...` lines fall through
" to the embedded-Python region below. The line splits into three colors:
" `//;` -> `libpyDelim`, ` # ` -> Comment (via `libpySentinel`),
" `endX` -> magenta (via `libpySentinelKw`).
syn region libpySentinel matchgroup=libpyDelim
    \ start=+//;\(\s*#\s*end\s*\(if\|for\|while\)\s*$\)\@=+
    \ end=+$+
    \ keepend oneline containedin=ALL
    \ contains=libpySentinelKw
syn match libpySentinelKw +end\s*\(if\|for\|while\)+ contained

" //;<rest> -- the rest of the line is Python (excluding the sentinel form
" above, which is matched separately).
syn region libpyLine matchgroup=libpyDelim
    \ start=+//;\(\s*#\s*end\s*\(if\|for\|while\)\s*$\)\@!+ end=+$+
    \ keepend containedin=ALL contains=@pythonTop

" `expr` -- inline Python expression.
"   * \\\@<! is "not preceded by a backslash" so the gvpy literal-backtick
"     escape (\`) does not open or close the region.
syn region libpyInline matchgroup=libpyDelim
    \ start=#\\\@<!`#
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
syn region libpyJ2Sentinel matchgroup=libpyDelim
    \ start=+{%-\?\(\s*#\s*end\s*\(if\|for\|while\)\s*-\?%}\)\@=+
    \ end=+-\?%}+
    \ keepend oneline containedin=ALL
    \ contains=libpySentinelKw

" {% python stmt %} -- excludes the sentinel form above.
syn region libpyJ2Stmt matchgroup=libpyDelim
    \ start=+{%-\?\(\s*#\s*end\s*\(if\|for\|while\)\s*-\?%}\)\@!+ end=+-\?%}+
    \ keepend containedin=ALL contains=@pythonTop

" {# template comment #} -- stripped at elaboration; pure comment.
syn region libpyJ2Comment matchgroup=libpyDelim
    \ start=+{#+ end=+#}+ keepend containedin=ALL

hi link libpyJ2Comment Comment
hi link libpyDelim PreProc

" Make embedded Python visually distinct from the Liberty base.
hi libpyPyKeyword  cterm=bold gui=bold ctermfg=magenta guifg=magenta
hi libpyPyBuiltin  cterm=bold gui=bold
hi libpyPyFunction cterm=bold gui=bold
hi link pythonStatement   libpyPyKeyword
hi link pythonConditional libpyPyKeyword
hi link pythonRepeat      libpyPyKeyword
hi link pythonOperator    libpyPyKeyword
hi link pythonException   libpyPyKeyword
hi link pythonInclude     libpyPyKeyword
hi link pythonBuiltin     libpyPyBuiltin
hi link pythonFunction    libpyPyFunction
hi link pythonDecorator   libpyPyKeyword

" Sentinel body (`#`, surrounding whitespace, and the `endX` keyword) is
" all bold magenta; only the surrounding `//;` / `{%` / `%}` delimiters
" keep their delim color.
hi libpySentinel cterm=bold gui=bold ctermfg=magenta guifg=magenta
hi link libpyJ2Sentinel  libpySentinel
hi link libpySentinelKw  libpySentinel

let b:current_syntax = "libpy"

" vim: set ts=4 sw=4:
