local util = require 'lspconfig.util'

local workspace_markers = { 'hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml' }

return {
  default_config = {
    cmd = { 'haskell-language-server-wrapper', '--lsp' },
    filetypes = { 'haskell', 'lhaskell' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
    settings = {
      haskell = {
        formattingProvider = 'ormolu',
      },
    },
    lspinfo = function(cfg)
      local extra = {}
      local function on_stdout(_, data, _)
        local version = data[1]
        table.insert(extra, 'version:   ' .. version)
      end

      local opts = {
        cwd = cfg.cwd,
        stdout_buffered = true,
        on_stdout = on_stdout,
      }
      local chanid = vim.fn.jobstart({ cfg.cmd[1], '--version' }, opts)
      vim.fn.jobwait { chanid }
      return extra
    end,
  },

  docs = {
    description = [[
https://github.com/haskell/haskell-language-server

Haskell Language Server
    ]],

    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
