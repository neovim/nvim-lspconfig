local root_files = {
  'Gothic.src',
  'Camera.src',
  'Menu.src',
  'Music.src',
  'ParticleFX.src',
  'SFX.src',
  'VisualFX.src',
}

return {
  default_config = {
    cmd = { 'DaedalusLanguageServer' },
    filetypes = { 'd' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ unpack(root_files) }, { path = fname, upward = true })[1])
    end,
    settings = {
      DaedalusLanguageServer = {
        loglevel = 'debug',
        inlayHints = { constants = true },
        numParserThreads = 16,
        fileEncoding = 'Windows-1252',
        srcFileEncoding = 'Windows-1252',
      },
    },
  },
}
