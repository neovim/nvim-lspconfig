local util = require 'lspconfig.util'
local bin_name = 'foam-ls'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'foam', 'OpenFOAM' },
    root_dir = function (fname)
        return util.search_ancestors(fname, function (path)
            if util.path.exists(util.path.join(path, "system", "controlDict")) then
               return path
            end
        end)
    end,
    log_level = vim.lsp.protocol.MessageType.Warning,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/FoamScience/foam-language-server/master/package.json',
    description = [[
https://github.com/FoamScience/foam-language-server

`foam-language-server` can be installed via `npm`
```sh
npm install -g foam-language-server
```
]],
  },
}
