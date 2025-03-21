local language_id_mapping = {
  bib = 'bibtex',
  pandoc = 'markdown',
  plaintex = 'tex',
  rnoweb = 'rsweave',
  rst = 'restructuredtext',
  tex = 'latex',
  text = 'plaintext',
}

local function get_language_id(_, filetype)
  return language_id_mapping[filetype] or filetype
end

return {
  default_config = {
    cmd = { 'ltex-ls-plus' },
    filetypes = {
      'bib',
      'context',
      'gitcommit',
      'html',
      'markdown',
      'org',
      'pandoc',
      'plaintex',
      'quarto',
      'mail',
      'mdx',
      'rmd',
      'rnoweb',
      'rst',
      'tex',
      'text',
      'typst',
      'xhtml',
    },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    get_language_id = get_language_id,
    settings = {
      ltex = {
        enabled = {
          'bib',
          'context',
          'gitcommit',
          'html',
          'markdown',
          'org',
          'pandoc',
          'plaintex',
          'quarto',
          'mail',
          'mdx',
          'rmd',
          'rnoweb',
          'rst',
          'tex',
          'latex',
          'text',
          'typst',
          'xhtml',
        },
      },
    },
  },
  docs = {
    description = [=[
https://github.com/ltex-plus/ltex-ls-plus

LTeX Language Server: LSP language server for LanguageTool 🔍✔️ with support for LaTeX 🎓, Markdown 📝, and others

To install, download the latest [release](https://github.com/ltex-plus/ltex-ls-plus) and ensure `ltex-ls-plus` is on your path.

This server accepts configuration via the `settings` key.

```lua
  settings = {
    ltex = {
      language = "en-GB",
    },
  },
```

To support org files or R sweave, users can define a custom filetype autocommand (or use a plugin which defines these filetypes):

```lua
vim.cmd [[ autocmd BufRead,BufNewFile *.org set filetype=org ]]
```
]=],
  },
}
