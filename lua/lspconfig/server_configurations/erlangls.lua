local util = require 'lspconfig.util'

local cmd = { 'erlang_ls' }
if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', 'erlang_ls.cmd' }
end

local workspace_markers = { 'rebar.config', 'erlang.mk', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'erlang' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://erlang-ls.github.io

Language Server for Erlang.

Clone [erlang_ls](https://github.com/erlang-ls/erlang_ls)
Compile the project with `make` and copy resulting binaries somewhere in your $PATH eg. `cp _build/*/bin/* ~/local/bin`

Installation instruction can be found [here](https://github.com/erlang-ls/erlang_ls).

Installation requirements:
    - [Erlang OTP 21+](https://github.com/erlang/otp)
    - [rebar3 3.9.1+](https://github.com/erlang/rebar3)
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
