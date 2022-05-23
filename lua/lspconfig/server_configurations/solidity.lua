local util = require 'lspconfig.util'

local bin_name = 'solidity-ls'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

return {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'solidity' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
Dependencies:

* [solidity-ls](https://github.com/qiuxiang/solidity-ls): `npm i solidity-ls -g`
* [solc](https://github.com/ethereum/solidity/releases/latest)
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
