return {
  default_config = {
    cmd = { 'vtsls', '--stdio' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' }, { path = fname, upward = true })[1]
      )
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/yioneko/vtsls

`vtsls` can be installed with npm:
```sh
npm install -g @vtsls/language-server
```

To configure a TypeScript project, add a
[`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)
or [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to
the root of your project.
]],
  },
}
