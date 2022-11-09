local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'pls' },
    settings = {
      perl = {
        perlcritic = { enabled = false },
        syntax = { enabled = true },
      },
    },
    filetypes = { 'perl' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/FractalBoy/perl-language-server
https://metacpan.org/pod/PLS

`PLS`, another language server for Perl.

To use the language server, ensure that you have PLS installed and that it is in your path
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
