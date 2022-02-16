-- Only `configs` must be required, util is optional if you are using the root
-- resolver functions, which is usually the case.
local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

-- Having server name defined here is the convention, this is often times also the first entry in the `cmd` table.
local server_name = "hdl_checker"

configs[server_name] = {
	default_config = {
		-- This should be executable on the command line, arguments (such as
		-- `--stdio`) are additional entries in the list.
		-- cmd = { 'pyright-langserver' },
		cmd = { "hdl_checker", "--lsp" },
		filetypes = { "vhdl", "verilog", "systemverilog" },
		root_dir = util.find_git_ancestor,
		single_file_support = true,
	},
	docs = {
		-- The description should include at minimum the link to the github
		-- project, and ideally the steps to install the language server.
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
