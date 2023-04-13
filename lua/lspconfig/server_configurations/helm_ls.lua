local util = require 'lspconfig.util'

local bin_name = 'helm_ls'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = { cmd, 'serve' },
    filetypes = { 'helm' },
    root_dir = util.root_pattern 'Chart.yaml',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/mrjosh/helm-ls

Helm Language server. (This LSP is in early development)

`helm Language server` can be installed by following the instructions [here](https://github.com/mrjosh/helm-ls).

The default `cmd` assumes that the `helm_ls` binary can be found in `$PATH`.

You'll need [vim-helm](https://github.com/towolf/vim-helm) plugin installed before using helm_ls
]],
    default_config = {
      root_dir = [[root_pattern("Chart.yaml)]],
    },
  },
}
