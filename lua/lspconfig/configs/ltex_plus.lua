local util = require 'lspconfig.util'

local language_id_mapping = {
  bib = 'bibtex',
  plaintex = 'tex',
  rnoweb = 'rsweave',
  rst = 'restructuredtext',
  tex = 'latex',
  pandoc = 'markdown',
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
      'gitcommit',
      'markdown',
      'org',
      'plaintex',
      'rst',
      'rnoweb',
      'tex',
      'pandoc',
      'quarto',
      'rmd',
      'context',
      'html',
      'xhtml',
      'mail',
      'text',
    },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    get_language_id = get_language_id,
    settings = {
      ltex = {
        enabled = {
          'bibtex',
          'context',
          'gitcommit',
          'html',
          'mail',
          'markdown',
          'org',
          'quarto',
          'restructuredtext',
          'rmd',
          'rsweave',
          'tex',
          'text',
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
