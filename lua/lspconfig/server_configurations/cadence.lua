local util = require 'lspconfig.util'

local config_name = 'flow.json'
local bin_name = 'flow'
local cmd = { 'flow', 'cadence', 'language-server' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'cadence', 'language-server' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'cdc' },
    init_options = {
      numberOfAccounts = '1',
    },
    root_dir = function(fname, _)
      return util.root_pattern(config_name)(fname) or vim.env.HOME
    end,
    on_new_config = function(new_config, new_root_dir)
      new_config.init_options.configPath = util.path.join(new_root_dir, config_name)
    end,
  },
  docs = {
    description = [[
[Cadence Language Server](https://github.com/onflow/cadence-tools/tree/master/languageserver)
using the [flow-cli](https://developers.flow.com/tools/flow-cli).

The `flow` command from flow-cli must be available. For install instructions see
[the docs](https://developers.flow.com/tools/flow-cli/install#install-the-flow-cli) or the
[Github page](https://github.com/onflow/flow-cli).

By default the configuration is taken from the closest `flow.json` or the `flow.json` in the users home directory.
]],
    default_config = {
      root_dir = [[util.root_pattern('flow.json') or vim.env.HOME]],
    },
  },
}
