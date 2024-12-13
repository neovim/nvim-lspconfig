return {
  default_config = {
    cmd = { 'glslls', '--stdin' },
    filetypes = { 'glsl', 'vert', 'tesc', 'tese', 'frag', 'geom', 'comp' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    capabilities = {
      textDocument = {
        completion = {
          editsNearCursor = true,
        },
      },
      offsetEncoding = { 'utf-8', 'utf-16' },
    },
  },
  docs = {
    description = [[
https://github.com/svenstaro/glsl-language-server

Language server implementation for GLSL

`glslls` can be compiled and installed manually, or, if your distribution has access to the AUR,
via the `glsl-language-server` AUR package
    ]],
  },
}
