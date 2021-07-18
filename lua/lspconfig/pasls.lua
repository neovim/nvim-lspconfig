local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.pasls = {
	default_config = {
		cmd = { 'paslsp' },
		cmd_env = {
			PP = 'fpc',
			FPCDIR = '/usr/lib/fpc/src',
			LAZARUSDIR =  '',
			FPCTARGET = '',
			FPCTARGETCPU = '',
		},
		filetypes = { 'pascal' },
		root_dir = util.path.dirname,
	},
	docs = {
		description=[[
		https://github.com/arjanadriaanse/pascal-language-server
		An LSP server implementation for Pascal variants that are supported by Free Pascal, including Object Pascal. It uses CodeTools from Lazarus as backend.
		]],
	},
}
