local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pug-lsp' },
    filetypes = { 'pug' },
    root_dir = util.find_package_json_ancestor,
  },
  docs = {
    description = [[
https://github.com/opa-oz/pug-lsp

An implementation of the Language Protocol Server for [Pug.js](http://pugjs.org)

PugLSP can be installed via `go get github.com/opa-oz/pug-lsp`, or manually downloaded from [releases page](https://github.com/opa-oz/pug-lsp/releases)
    ]],
  },
}
