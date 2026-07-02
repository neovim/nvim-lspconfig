---@brief
---
--- https://github.com/owenrumney/make-ls
---
--- `make-ls`, a language server for Makefiles.
---

---@type vim.lsp.Config
return {
  cmd = { 'make-ls' },
  filetypes = { 'make' },
  root_markers = {
    'Makefile',
    'makefile',
    'GNUmakefile',
  },
}
