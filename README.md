# genesis-editors

Editor support files for the genesispy / gvpy / genesis2 toolchain, consolidated
from the per-repo `extras/` directories.

## Layout

- [`vim/`](vim/README.md)       -- Vim ftdetect + syntax for both tools.
- [`emacs/`](emacs/README.md)   -- Emacs major modes (`genesispy-mode`, `genesis2-mode`).
- [`vscode/`](vscode/README.md) -- VS Code extension sources (build with `vsce package`).

See the linked per-subdirectory `README.md` for install instructions.

## Supported file extensions

| Extension | Tool       | Major mode / filetype |
|-----------|------------|-----------------------|
| `.vpy`    | genesispy  | `genesispy`           |
| `.svpy`   | genesispy  | `genesispy`           |
| `.gvpy`   | genesispy  | `genesispy`           |
| `.vpyh`   | genesispy  | `genesispy`           |
| `.vp`     | genesis2   | `genesis2`            |
| `.svp`    | genesis2   | `genesis2`            |
| `.vph`    | genesis2   | `genesis2`            |

