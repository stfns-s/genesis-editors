# VS Code support for Genesis2 templates

TextMate grammar for Perl-templated Verilog/SystemVerilog files
(`.vp` / `.svp` / `.vph`).

Composes the SystemVerilog grammar from
[`mshr-h.veriloghdl`](https://marketplace.visualstudio.com/items?itemName=mshr-h.veriloghdl)
with VS Code's bundled `source.perl` grammar:

- SystemVerilog tokens as the base (handles plain Verilog fine).
- `//;`-prefixed lines highlighted as Perl (`source.perl`).
- Backtick-delimited inline expressions, escape-aware (`` \` ``) and
  excluding Verilog backtick directives (`` `timescale ``, `` `ifdef ``, ...).
- Comment-only embedded lines (`//; # ...`) scoped as comments so
  block-closing sentinels read distinctly.
- Declaration-keyword fallback: when a declarator name is backtick-
  templated (e.g. `` module `mname` ``), the base grammar's region rule
  (which requires a literal identifier) fails and the keyword falls
  through to a generic-identifier scope. This grammar adds a fallback
  that scopes `module` / `endmodule` / `interface` / `function` /
  `task` / `class` / `package` / etc. so they still pick up the theme's
  `storage.type` colour.

Genesis2 has no Jinja2 (`--j2`) support; the grammar omits `{% %}` /
`{# #}` rules.

## Known limitation

The file's language id is `genesis2`, not `systemverilog`, so
`mshr-h.veriloghdl`'s semantic-token provider does not activate -- any
**bold** styling it adds to Verilog/SystemVerilog tokens in `.v`/`.sv`
files will be absent in `.vp` files. Foreground colours are unaffected.

To force the same boldness manually, add a per-language rule to your
user `settings.json`:

```jsonc
"editor.tokenColorCustomizations": {
  "[Genesis2]": {
    "textMateRules": [
      { "scope": "storage.type",                "settings": { "fontStyle": "bold" } },
      { "scope": "keyword.control.systemverilog", "settings": { "fontStyle": "bold" } }
    ]
  }
}
```

## Prerequisite

Install the `mshr-h.veriloghdl` extension first -- this extension
embeds its `source.systemverilog` grammar. It is also declared as an
`extensionDependencies` entry, so VS Code will offer to install it
automatically on first load.

## Install

The supported install path is to build a `.vsix` package and install it
through VS Code. Modern VS Code only loads extensions it has registered
itself; a bare folder dropped into `~/.vscode/extensions/` is ignored.

### Build the .vsix

Requires `node` and `npx` (any recent Node.js). From the repo root:

```sh
cd vscode/genesis2
npx --yes @vscode/vsce package --allow-missing-repository
```

This produces `vscode/genesis2/genesis2-<version>.vsix`. The file is
build output and is not committed.

### Install the .vsix

**GUI (recommended):**

1. `Ctrl+Shift+X` to open the Extensions view.
2. Top of the panel -> `...` menu -> **Install from VSIX...**.
3. Browse to `vscode/genesis2/genesis2-<version>.vsix`.
4. Reload the window when prompted
   (`Ctrl+Shift+P` -> `Developer: Reload Window`).

**CLI:**

```sh
code --install-extension vscode/genesis2/genesis2-<version>.vsix
```

(Skip the CLI form if your `code` invocation is intercepted by a running
remote VS Code instance -- use the GUI path instead.)

### Update or uninstall

- Update: rebuild the `.vsix` with a bumped version in `package.json`
  and re-install through the same GUI flow. VS Code replaces the old
  version in place.
- Uninstall: Extensions view -> "Genesis2" -> gear icon -> **Uninstall**.

### Symlink (grammar development)

When iterating on the grammar, skip repackaging by symlinking the source
into the extensions dir *and* registering it once via a `.vsix`:

```sh
# one-time: build & install so VS Code registers the extension id
cd vscode/genesis2 && npx --yes @vscode/vsce package --allow-missing-repository
code --install-extension genesis2-*.vsix
# then replace the installed copy with a symlink to your source
INSTALLED=$(ls -d ~/.vscode/extensions/genesispy.genesis2-* | head -1)
rm -rf "$INSTALLED"
ln -s "$PWD" "$INSTALLED"
```

Reload the VS Code window after each grammar edit to pick up changes.

## Verify

- Open a `.vp`, `.svp`, or `.vph` file. The status bar should read
  **Genesis2**.
- On a `//;` line, run `Ctrl+Shift+P` -> `Developer: Inspect Editor
  Tokens and Scopes`. Expect `meta.embedded.line.perl` and
  `source.perl` scopes.
- A `` `timescale 1ns/1ps `` line stays Verilog; `` `name` `` inline
  picks up Perl colouring.

## Files

- `package.json` -- manifest, language + grammar contributions.
- `language-configuration.json` -- comments, brackets, auto-closing pairs.
- `syntaxes/genesis2.tmLanguage.json` -- the TextMate grammar.

## Notes

- The `mshr-h.veriloghdl` linter/formatter settings are independent of
  this grammar and continue to apply to the SystemVerilog base.
- No formatter or snippets shipped here -- `mshr-h.veriloghdl` already
  provides SystemVerilog snippets.
