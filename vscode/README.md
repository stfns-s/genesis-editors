# VS Code support for genesispy / genesis2 templates

Three independent VS Code extensions, one per template variant:

- [`genesispy/`](genesispy/README.md) -- Python-templated Verilog
  (`.vpy` / `.svpy` / `.gvpy` / `.vpyh`).
- [`genesis2/`](genesis2/README.md) -- Perl-templated Verilog
  (`.vp` / `.svp` / `.vph`).
- [`libpy/`](libpy/README.md) -- Python-templated Liberty
  (`.lpy` / `.libpy`).

Each subdirectory is a self-contained extension with its own
`package.json`, grammar, and build instructions. Install whichever
variant(s) you need; they are independent and may be installed
side-by-side.

`genesispy/` and `genesis2/` depend on
[`mshr-h.veriloghdl`](https://marketplace.visualstudio.com/items?itemName=mshr-h.veriloghdl)
for the SystemVerilog base grammar (declared as an
`extensionDependencies` entry, so VS Code offers to install it
automatically on first load). `libpy/` has no base grammar (VS Code has
no Liberty grammar) and no dependency: it highlights the embedded Python
only.
