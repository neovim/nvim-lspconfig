local util = require 'lspconfig.util'

local function get_lsp_config_path()
  -- first find *.dpr project file, as lsp config might not be present
  local dpr_path = vim.fs.find(function(name)
    return name:match '.*%.dpr$'
  end, { type = 'file', upward = true })[1]

  -- if found, then lsp config should be located in the same folder
  if dpr_path then
    return vim.fs.find(function(name)
      return name:match '.*%.delphilsp.json$'
    end, { type = 'file', path = vim.fs.dirname(dpr_path), upward = false })[1]
  end
end

return {
  default_config = {
    cmd = { 'DelphiLSP.exe' },
    filetypes = { 'pascal' },
    root_dir = util.root_pattern '*.dpr',
    single_file_support = true,
    settings = {
      -- set *.delphilsp.json - Delphi lsp config file path
      settingsFile = get_lsp_config_path(),
    },
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
