return {
  default_config = {
    cmd = { 'emmet-ls', '--stdio' },
    filetypes = {
      'astro',
      'css',
      'eruby',
      'html',
      'htmldjango',
      'javascriptreact',
      'less',
      'pug',
      'sass',
      'scss',
      'svelte',
      'typescriptreact',
      'vue',
      'htmlangular',
    },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/aca/emmet-ls

Package can be installed via `npm`:
```sh
npm install -g emmet-ls
```
]],
  },
}
