# Vim support for Genesis2/genesispy templates

Filetype detection and syntax highlighting for both template variants:

- **`genesis2`** — Perl-templated Verilog/SystemVerilog (`.vp`, `.svp`, `.vph`,
  `.gvp`, `.vpi`, `.svph`).
- **`genesispy`** — Python-templated variant used by `gvpy.py` (`.vpy`, `.svpy`, `.gvpy`, `.vpyh`).

Highlights:
- Verilog (or SystemVerilog if `syntax/verilog_systemverilog.vim` is on the
  runtime path) as the base.
- `//;`-prefixed embedded-language lines highlighted via `@perlTop` (genesis2)
  or `@pythonTop` (genesispy).
- Backtick-delimited inline expressions, escape-aware (`` \` ``) and
  excluding Verilog backtick directives (`` `timescale ``, `` `ifdef ``, ...).
- Comment-only embedded lines (`//; # ...`) highlighted bold so they stand out
  from regular statements.
- `--j2` delimiters in `genesispy` files: `{% stmt %}` (with `@pythonTop`),
  `{% # ... %}` sentinel (bold-comment), and `{# ... #}` (comment). The
  `{{ expr }}` form is intentionally left as plain Verilog to avoid colliding
  with brace-concat / replication patterns in non-j2 sources.

## Install

### Manual

Copy (or symlink) all four files into your vim runtime:

```sh
mkdir -p ~/.vim/after/ftdetect ~/.vim/syntax
cp after/ftdetect/genesis2.vim  ~/.vim/after/ftdetect/genesis2.vim
cp after/ftdetect/genesispy.vim ~/.vim/after/ftdetect/genesispy.vim
cp syntax/genesis2.vim          ~/.vim/syntax/genesis2.vim
cp syntax/genesispy.vim         ~/.vim/syntax/genesispy.vim
```

Both ftdetect files live under `after/` and use `set filetype=` (force) so they
run last and win against any plugin whose ftdetect claims the same extensions
and uses `au!` to clear earlier autocmds — for example `verilog_systemverilog`,
which maps `*.vp` to a different filetype.

For Neovim, swap `~/.vim` for `~/.config/nvim`.

### Plugin manager

Point your manager at this subdirectory. With `vim-plug`:

```vim
Plug 'youruser/genesis-editors', { 'rtp': 'vim' }
```

(Adjust the source spec for your fork/clone location.)

## Files

- `after/ftdetect/genesis2.vim` — maps `*.vp`, `*.svp`, `*.vph`, `*.gvp`,
  `*.vpi`, `*.svph` to filetype `genesis2`, forcing the filetype so it overrides
  plugins that also claim `*.vp`. Lives under `after/` so it runs last (see
  install notes above).
- `after/ftdetect/genesispy.vim` — maps `*.vpy`, `*.svpy`, `*.gvpy`, `*.vpyh`
  to filetype `genesispy`, forcing the filetype. Lives under `after/` so it runs
  last (see install notes above).
- `syntax/genesis2.vim` — Perl-embedded syntax rules layered on top of
  Verilog/SystemVerilog.
- `syntax/genesispy.vim` — Python-embedded syntax rules layered on top of
  Verilog/SystemVerilog.
