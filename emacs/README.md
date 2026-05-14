# Emacs support for Genesis2 / genesispy templates

Two major modes:

- **`genesis2-mode`** — Perl-templated Verilog/SystemVerilog (`.vp`, `.svp`, `.vph`).
- **`genesispy-mode`** — Python-templated variant used by `gvpy.py` (`.vpy`, `.svpy`, `.gvpy`, `.vpyh`).

Both derive from `verilog-mode` and use `mmm-mode` to layer the embedded
language (`perl-mode` or `python-mode`) onto `//;` lines and backtick
expressions. `genesispy-mode` additionally highlights the `--j2`
delimiters `{% stmt %}`, `{% # ... %}` sentinel, and `{# ... #}` comment;
`{{ expr }}` is left as plain Verilog to avoid clashes with brace-concat /
replication patterns in non-j2 sources.

## Install

```sh
mkdir -p ~/.emacs.d/lisp/mmm
curl -sSL https://melpa.org/packages/mmm-mode-20240222.428.tar \
    | tar -x --strip-components=1 -C ~/.emacs.d/lisp/mmm
cp genesis2-mode.el  ~/.emacs.d/
cp genesispy-mode.el ~/.emacs.d/
```

Add to `~/.emacs.d/init.el`:

```elisp
(add-to-list 'load-path "~/.emacs.d/lisp/mmm")
(require 'mmm-mode)
(load "~/.emacs.d/genesis2-mode")
(load "~/.emacs.d/genesispy-mode")
(setq mmm-submode-decoration-level 0)
(setq mmm-global-mode 'maybe)
```

## Verify

- Open a `.vpy` / `.svp` file. The mode line should read **Genesispy** /
  **Genesis2**.
- On a `//;` line, `C-u C-x =` should report `python-mode` (or `perl-mode`
  for genesis2) as the major mode at point, confirming `mmm-mode` has
  applied the submode region.
- A `` `timescale 1ns/1ps `` line stays Verilog; `` `i+1` `` inline picks
  up the submode face.

## Files

- `genesis2-mode.el` — Perl-embedded major mode derived from `verilog-mode`.
- `genesispy-mode.el` — Python-embedded major mode (adds `--j2` delimiter
  highlighting on top of the genesis2 rules).
