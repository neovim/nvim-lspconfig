local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'awk-language-server' },
    filetypes = { 'awk' },
    root_dir = function(fname)
      return util.path.dirname(fname)
    end,
    single_file_support = true,
    handlers = {
      ['workspace/workspaceFolders'] = function()
        return {
          result = nil,
          error = nil,
        }
      end,
    },
  },
  docs = {
    description = [[
https://github.com/Beaglefoot/awk-language-server/

`awk-language-server` can be installed via `npm`:
```sh
npm install -g awk-language-server
```
]],
  },
}
