return {
  default_config = {
    cmd = { 'postgrestools', 'lsp-proxy' },
    filetypes = {
      'sql',
    },
    root_dir = vim.fs.root(0, { 'postgrestools.jsonc' }),
    single_file_support = true,
  },
  docs = {
    description = [[
https://pgtools.dev

A collection of language tools and a Language Server Protocol (LSP) implementation for Postgres, focusing on developer experience and reliable SQL tooling.
        ]],
  },
}
