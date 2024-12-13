return {
  default_config = {
    cmd = { 'glsl_analyzer' },
    filetypes = { 'glsl', 'vert', 'tesc', 'tese', 'frag', 'geom', 'comp' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    capabilities = {},
  },
  docs = {
    description = [[
https://github.com/nolanderc/glsl_analyzer

Language server for GLSL
    ]],
  },
}
