return {
  default_config = {
    cmd = { 'prisma-language-server', '--stdio' },
    filetypes = { 'prisma' },
    settings = {
      prisma = {
        prismaFmtBinPath = '',
      },
    },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git', 'package.json' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
Language Server for the Prisma JavaScript and TypeScript ORM

`@prisma/language-server` can be installed via npm
```sh
npm install -g @prisma/language-server
```
]],
  },
}
