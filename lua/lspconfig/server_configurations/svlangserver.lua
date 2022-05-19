local util = require 'lspconfig.util'

local bin_name = 'svlangserver'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

local function build_index()
  local params = {
    command = 'systemverilog.build_index',
  }
  vim.lsp.buf.execute_command(params)
end

local function report_hierarchy()
  local params = {
    command = 'systemverilog.report_hierarchy',
    arguments = { vim.fn.expand '<cword>' },
  }
  vim.lsp.buf.execute_command(params)
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'verilog', 'systemverilog' },
    root_dir = function(fname)
      return util.root_pattern '.nvim'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    settings = {
      systemverilog = {
        includeIndexing = { '*.{v,vh,sv,svh}', '**/*.{v,vh,sv,svh}' },
      },
    },
    on_init = function(client)
      local json = ''
      for line in io.lines(client.config.root_dir .. '/.nvim/lspconfig.json') do
        json = json .. line
      end
      json = vim.json.decode(json)
      client.config.cmd = { json.languageserver.svlangserver.command }
      client.config.filetypes = json.languageserver.svlangserver.filetypes
      client.config.settings = json.languageserver.svlangserver.settings
    end,
  },
  commands = {
    SvlangserverBuildIndex = {
      build_index,
      description = 'Instructs language server to rerun indexing',
    },
    SvlangserverReportHierarchy = {
      report_hierarchy,
      description = 'Generates hierarchy for the given module',
    },
  },
  docs = {
    description = [[
https://github.com/imc-trading/svlangserver

`svlangserver`, a language server for systemverilog
]],
  },
}
