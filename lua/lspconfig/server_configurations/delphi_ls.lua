local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'DelphiLSP.exe' },
    filetypes = { 'pascal' },
    root_dir = util.root_pattern('*.dpr'),
    single_file_support = true,
    settings = {
      --look for *.delphilsp.json - Delphi lsp config file
      settingsFile = vim.fs.find(function(name) return name:match('.*%.delphilsp.json$') end, {limit = math.huge, type = 'file' , upward = true})[1]
    }
  },
  docs = {
    description = [[
Language server for Delphi from Embarcadero.
https://marketplace.visualstudio.com/items?itemName=EmbarcaderoTechnologies.delphilsp

Note, the '*.delphilsp.json' file is required, more details at:
https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Using_DelphiLSP_Code_Insight_with_Other_Editors
]],
  },
}
