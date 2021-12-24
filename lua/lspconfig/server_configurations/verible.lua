local util = require("lspconfig.util")

return {
	default_config = {
		cmd = { "verible-verilog-ls" },
		filetypes = { "systemverilog", "verilog" },
		root_dir = function(fname)
			return util.find_git_ancestor(fname)
		end,
	},
	docs = {
		description = [[
https://github.com/chipsalliance/verible

A linter and formatter for verilog and SystemVerilog files.

See https://github.com/chipsalliance/verible/tree/master/verilog/tools/ls/README.md for options.
    ]],
	},
}
