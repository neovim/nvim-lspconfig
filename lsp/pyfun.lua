---@brief
---
--- https://github.com/simontreanor/Pyfun
---
--- Language server for Pyfun, an F#-inspired, functional-first language that
--- compiles to readable Python.
---
--- The `pyfun` binary ships with the compiler and can be installed via pip:
---
--- ```sh
--- pip install pyfun-lang
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'pyfun', 'lsp' },
  filetypes = { 'pyfun' },
  root_markers = { '.git' },
}
