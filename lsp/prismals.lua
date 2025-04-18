---@brief
---
--- Language Server for the Prisma JavaScript and TypeScript ORM
---
--- `@prisma/language-server` can be installed via npm
--- ```sh
--- npm install -g @prisma/language-server
--- ```
return {
  cmd = { 'prisma-language-server', '--stdio' },
  filetypes = { 'prisma' },
  settings = {
    prisma = {
      prismaFmtBinPath = '',
    },
  },
  root_markers = { '.git', 'package.json' },
}
