# VS Code support for libpy templates

TextMate grammar for Python-templated Liberty files (`.lpy` / `.libpy`).

Overlay only: there is no Liberty base grammar in VS Code, so this extension
highlights the embedded-Python directives and leaves the Liberty body as plain
text. It uses VS Code's bundled `source.python` grammar:

- `//;`-prefixed lines highlighted as Python (`source.python`).
- Backtick-delimited inline expressions, escape-aware (`` \` ``).
- Comment-only embedded lines (`//; # ...`) scoped as comments so
  block-closing sentinels (`# endfor`, `# endif`, ...) read distinctly.
- `--j2` delimiters: `{% python %}` blocks, `{% # ... %}` comment-only
  sentinel (scoped as a comment so block closers stand out), and
  `{# ... #}` comments. `{{ ... }}` is intentionally not highlighted, matching
  the genesispy grammar.

There is no `extensionDependencies` entry -- the extension is self-contained.

## Install

The supported install path is to build a `.vsix` package and install it
through VS Code. Modern VS Code only loads extensions it has registered
itself; a bare folder dropped into `~/.vscode/extensions/` is ignored.

### Build the .vsix

Requires `node` and `npx` (any recent Node.js). From the repo root:

```sh
cd vscode/libpy
npx --yes @vscode/vsce package --allow-missing-repository
```

This produces `vscode/libpy/libpy-<version>.vsix`. The file is build output
and is not committed.

### Install the .vsix

**GUI (recommended):**

1. `Ctrl+Shift+X` to open the Extensions view.
2. Top of the panel -> `...` menu -> **Install from VSIX...**.
3. Browse to `vscode/libpy/libpy-<version>.vsix`.
4. Reload the window when prompted
   (`Ctrl+Shift+P` -> `Developer: Reload Window`).

**CLI:**

```sh
code --install-extension vscode/libpy/libpy-<version>.vsix
```

(Skip the CLI form if your `code` invocation is intercepted by a running
remote VS Code instance -- use the GUI path instead.)

### Update or uninstall

- Update: rebuild the `.vsix` with a bumped version in `package.json`
  and re-install through the same GUI flow. VS Code replaces the old
  version in place.
- Uninstall: Extensions view -> "Libpy" -> gear icon -> **Uninstall**.

### Symlink (grammar development)

When iterating on the grammar, skip repackaging by symlinking the source
into the extensions dir *and* registering it once via a `.vsix`:

```sh
# one-time: build & install so VS Code registers the extension id
cd vscode/libpy && npx --yes @vscode/vsce package --allow-missing-repository
code --install-extension libpy-*.vsix
# then replace the installed copy with a symlink to your source
INSTALLED=$(ls -d ~/.vscode/extensions/libpy.libpy-* | head -1)
rm -rf "$INSTALLED"
ln -s "$PWD" "$INSTALLED"
```

Reload the VS Code window after each grammar edit to pick up changes.

## Verify

- Open a `.lpy` or `.libpy` file. The status bar should read **Libpy**.
- On a `//;` line, run `Ctrl+Shift+P` -> `Developer: Inspect Editor
  Tokens and Scopes`. Expect `meta.embedded.line.python` and
  `source.python` scopes.
- An `` `mname` `` inline expression picks up Python colouring; the
  surrounding Liberty text stays plain.

## Files

- `package.json` -- manifest, language + grammar contributions.
- `language-configuration.json` -- comments, brackets, auto-closing pairs.
- `syntaxes/libpy.tmLanguage.json` -- the TextMate grammar.
