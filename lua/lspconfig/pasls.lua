local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.pasls = {
  default_config = {
    cmd = { 'pasls' },
    cmd_env = {
      FPCDIR = '/usr/lib/fpc/src',
      PP = '/usr/lib/fpc/3.2.2/ppcx64',
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
		First set `cmd` to the Pascal lsp binary.
		Customization options are passed to pasls as environment variables for example:
		```lua
		require'lspconfig'.pasls.setup {
		cmd = { 'pasls' },
		cmd_env = {
		FPCDIR = '/usr/lib/fpc/src',
		PP = '/usr/lib/fpc/3.2.2/ppcx64',
		LAZARUSDIR = '/usr/lib/lazarus',
		FPCTARGET = '',
		FPCTARGETCPU = 'x86_64',
		},
		}
		```
		`FPCDIR` : set this to your FPC source location.
		`PP` : Path to the Free Pascal compiler executable.
		`LAZARUSDIR` : Path to the Lazarus sources.
		`FPCTARGET` : Target operating system for cross compiling.
		`FPCTARGETCPU` : Target CPU for cross compiling.
		]],
  },
}
