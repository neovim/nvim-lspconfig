local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

local server_name = "hdl_checker"

configs[server_name] = {
	default_config = {
		cmd = { "hdl_checker", "--lsp" },
		filetypes = { "vhdl", "verilog", "systemverilog" },
		root_dir = util.find_git_ancestor,
		single_file_support = true,
	},
	docs = {
		description = [[
https://github.com/suoto/hdl_checker
Language server for hdl-checker.
Install using: `pip install hdl-checker --upgrade`
]],
		default_config = {
			root_dir = [[util.find_git_ancestor]],
		},
	},
}
