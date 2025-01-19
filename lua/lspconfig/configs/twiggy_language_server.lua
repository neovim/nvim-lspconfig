return {
  default_config = {
    cmd = { 'twiggy-language-server', '--stdio' },
    filetypes = { 'twig' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'composer.json', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/moetelo/twiggy

`twiggy-language-server` can be installed via `npm`:
```sh
npm install -g twiggy-language-server
```
]],
  },
}
