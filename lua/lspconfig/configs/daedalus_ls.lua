-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
