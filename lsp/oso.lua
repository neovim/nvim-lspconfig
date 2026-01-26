---@brief
--- https://www.osohq.com/docs/develop/local-dev/env-setup
---
--- Oso Polar language server.
---
--- `oso-cloud` can be installed by following the instructions
--- [here](https://www.osohq.com/docs/develop/local-dev/env-setup).
---
--- The default `cmd` assumes that the `oso-cloud` binary can be found in the `$PATH`.
---
--- You may need to configure the filetype for Polar (*.polar) files:
---
--- ```
--- autocmd BufNewFile,BufRead *.polar set filetype=polar
--- ```
---
--- or
---
--- ```lua
--- vim.filetype.add({
---   pattern = {
---     ['.*/*.polar'] = 'polar',
---   },
--- })
---
--- Alternatively, you may use a syntax plugin like https://github.com/osohq/polar.vim

---@type vim.lsp.Config
return {
  cmd = { 'oso-cloud', 'lsp' },
  filetypes = { 'polar' },
}
