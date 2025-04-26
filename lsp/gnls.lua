---@brief
---
--- https://github.com/microsoft/gnls
---
--- Microsoft's language server for GN build files.
---
--- Assuming there is a `gnls` script somewhere in your `$PATH`, containing
--- for example:
---
--- ```shell
--- GNLS_SRC_DIR=</path/to/gnls>
---
--- exec node ${GNLS_SRC_DIR}/build/server.js $@
--- ```
return {
  cmd = { 'gnls', '--stdio' },
  filetypes = { 'gn' },
  root_markers = { '.gn', '.git' },
}
