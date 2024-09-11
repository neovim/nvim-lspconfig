local util = require 'lspconfig.util'

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
    root_dir = util.root_pattern(unpack(root_files)),
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
