---@brief
---
--- https://github.com/djlint/djLint
---
--- Linter and formatter for HTML templates. Needs djLint 1.49 or newer.
---
--- ```sh
--- pip install djlint
--- ```
---
--- Neovim gives some template extensions (`.j2`, `.njk`, `.gotmpl`, `.mako` and others) no
--- filetype, see the [docs](https://djlint.com/docs/integrations/#neovim) to register them, and the
--- [settings](https://djlint.com/docs/integrations/#settings).

---@type vim.lsp.Config
return {
  cmd = { 'djlint', '--lsp' },
  filetypes = {
    'html',
    'htmldjango',
    'htmlangular',
    'jinja',
    'jinja.html',
    'nunjucks',
    'twig',
    'handlebars',
    'mustache',
    'liquid',
    'gotmpl',
    'tera',
    'mako',
  },
  root_markers = { 'pyproject.toml', 'djlint.toml', '.djlint.toml', '.djlintrc', '.git' },
}
