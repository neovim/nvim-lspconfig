--- @brief
---
--- DaedalusLanguageServer

return {
  cmd = { 'DaedalusLanguageServer' },
  filetypes = { 'd' },
  root_markers = {
    'Gothic.src',
    'Camera.src',
    'Menu.src',
    'Music.src',
    'ParticleFX.src',
    'SFX.src',
    'VisualFX.src',
  },
  settings = {
    DaedalusLanguageServer = {
      loglevel = 'debug',
      inlayHints = { constants = true },
      numParserThreads = 16,
      fileEncoding = 'Windows-1252',
      srcFileEncoding = 'Windows-1252',
    },
  },
}
