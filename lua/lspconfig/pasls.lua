local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.pasls = {
  default_config = {
    cmd = { 'pasls' },
    cmd_env = {
      PP = '/usr/lib/fpc/3.2.2/ppcx64',
      FPCDIR = '/usr/lib/fpc/src',
      LAZARUSDIR = '/usr/lib/lazarus',
      FPCTARGET = '',
      FPCTARGETCPU = 'x86_64',
    },
    filetypes = { 'pascal' },
    root_dir = util.path.dirname,
  },
  docs = {
    description = [[
		https://github.com/genericptr/pascal-language-server
		An LSP server implementation for Pascal variants that are supported by Free Pascal, including Object Pascal. It uses CodeTools from Lazarus as backend.
		]],
  },
}
