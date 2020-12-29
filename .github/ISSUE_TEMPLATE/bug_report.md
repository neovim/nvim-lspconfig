---
name: Bug report
about: Report a problem in nvim-lsp
title: ''
labels: bug

---

<!-- Before reporting: search existing issues. Note that this repository implements configuration and initialization of language servers. Implementation of the language server spec itself is located in the neovim core repository-->

- `nvim --version`:
- nvim-lsp version(commit hash):
- `:checkhealth` result
- What language server(If the problem is related to a specific language server):
- Can you reproduce this behavior on other language server clients (vscode, languageclient-neovim, coc.nvim, etc.):
- Can you reproduce this behavior on other language servers offer by the nvim-lspconfig repo? (pyls -> pyright):
- Is this problem isolated to this particular language server:
- Operating system/version:
- Terminal name/version:
- `$TERM`:

### How to reproduce the problem from neovim startup

### Actual behaviour

### Expected behaviour

### LSP log
<!-- Please add vim.lsp.set_log_level("debug") to your lua block in init.vim and paste a link to your log file, located at $HOME/.local/share/nvim/lsp.log -->
