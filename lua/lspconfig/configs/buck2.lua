-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'buck2', 'lsp' },
    filetypes = { 'bzl' },
    root_dir = function(fname)
      return util.root_pattern '.buckconfig'(fname)
    end,
  },
  docs = {
    description = [=[
https://github.com/facebook/buck2

Build system, successor to Buck

To better detect Buck2 project files, the following can be added:

```
vim.cmd [[ autocmd BufRead,BufNewFile *.bxl,BUCK,TARGETS set filetype=bzl ]]
```
]=],
  },
}
