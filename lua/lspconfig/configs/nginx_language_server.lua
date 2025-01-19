return {
  default_config = {
    cmd = { 'nginx-language-server' },
    filetypes = { 'nginx' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'nginx.conf', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://pypi.org/project/nginx-language-server/

`nginx-language-server` can be installed via pip:

```sh
pip install -U nginx-language-server
```
    ]],
  },
}
