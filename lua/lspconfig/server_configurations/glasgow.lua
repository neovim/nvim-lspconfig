local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'glasgow' },
    filetypes = { 'wgsl' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/nolanderc/glasgow

Provides language features for WGSL (WebGPU Shading Language):
- Completions:
    - Local functions/variables/types.
    - Fields and swizzles.
    - Builtin types and functions (`dot`, `reflect`, `textureSample`, `vec3`, `mat4x2`, etc.)
- Hover Documentation:
    - Function signatures.
    - Variable types.
    - Includes builtin types and functions. Text is taken from the WGSL specification.
- Goto Definition
- Find all References
- Rename
- Formatter

`glasgow` can be installed via `cargo`:
```sh
cargo install glasgow
```
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
