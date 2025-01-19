return {
  default_config = {
    cmd = { 'psalm', '--language-server' },
    filetypes = { 'php' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'psalm.xml', 'psalm.xml.dist' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/vimeo/psalm

Can be installed with composer.
```sh
composer global require vimeo/psalm
```
]],
  },
}
