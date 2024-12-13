return {
  default_config = {
    cmd = { 'language-server-bitbake', '--stdio' },
    filetypes = { 'bitbake' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = false,
  },
  docs = {
    description = [[
https://github.com/yoctoproject/vscode-bitbake/tree/staging/server
https://www.npmjs.com/package/language-server-bitbake

Official Bitbake Language Server for the Yocto Project.

Can be installed from npm or github.

```
npm install -g language-server-bitbake
```
    ]],
  },
}
