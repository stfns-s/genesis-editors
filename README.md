# genesis-editors

Editor support files for the genesispy / gvpy / genesis2 toolchain, consolidated
from the per-repo `extras/` directories.

## Layout

- [`vim/`](vim/README.md)       -- Vim ftdetect + syntax for both tools.
- [`emacs/`](emacs/README.md)   -- Emacs major modes (`genesispy-mode`, `genesis2-mode`).
- [`vscode/`](vscode/README.md) -- VS Code extension sources (build with `vsce package`).

See the linked per-subdirectory `README.md` for install instructions.

## Supported file extensions

| Extension | Tool      | Base language | Emacs mode           | Vim filetype | VS Code language |
|-----------|-----------|---------------|----------------------|--------------|------------------|
| `.vpy`    | genesispy | Verilog       | `genesispy-mode`     | `genesispy`  | `genesispy`      |
| `.svpy`   | genesispy | Verilog       | `genesispy-mode`     | `genesispy`  | `genesispy`      |
| `.gvpy`   | genesispy | Verilog       | `genesispy-mode`     | `genesispy`  | `genesispy`      |
| `.vpyh`   | genesispy | Verilog       | `genesispy-mode`     | `genesispy`  | `genesispy`      |
| `.cpppy`  | genesispy | C++           | `genesispy-cpp-mode` | `genesispy`  | `genesispy-cpp`  |
| `.cppgpy` | genesispy | C++           | `genesispy-cpp-mode` | `genesispy`  | `genesispy-cpp`  |
| `.cpy`    | genesispy | C             | `genesispy-c-mode`   | `genesispy`  | `genesispy-c`    |
| `.cgpy`   | genesispy | C             | `genesispy-c-mode`   | `genesispy`  | `genesispy-c`    |
| `.vp`     | genesis2  | Verilog       | `genesis2-mode`      | `genesis2`   | `genesis2`       |
| `.svp`    | genesis2  | Verilog       | `genesis2-mode`      | `genesis2`   | `genesis2`       |
| `.vph`    | genesis2  | Verilog       | `genesis2-mode`      | `genesis2`   | `genesis2`       |
| `.gvp`    | genesis2  | Verilog       | `genesis2-mode`      | `genesis2`   | `genesis2`       |
| `.vpi`    | genesis2  | Verilog       | `genesis2-mode`      | `genesis2`   | `genesis2`       |
| `.svph`   | genesis2  | Verilog       | `genesis2-mode`      | `genesis2`   | `genesis2`       |

genesispy has no built-in C or C++ extension; a project registers one with
`--extension .cpppy=.cpp` (or `.cpy=.c`).

