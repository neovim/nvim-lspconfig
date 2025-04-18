---@brief
---
--- https://github.com/svenstaro/glsl-language-server
---
--- Language server implementation for GLSL
---
--- `glslls` can be compiled and installed manually, or, if your distribution has access to the AUR,
--- via the `glsl-language-server` AUR package
return {
  cmd = { 'glslls', '--stdin' },
  filetypes = { 'glsl', 'vert', 'tesc', 'tese', 'frag', 'geom', 'comp' },
  root_markers = { '.git' },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
}
