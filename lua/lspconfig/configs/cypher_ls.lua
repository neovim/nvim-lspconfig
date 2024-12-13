return {
  default_config = {
    cmd = { 'cypher-language-server', '--stdio' },
    filetypes = { 'cypher' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/neo4j/cypher-language-support/tree/main/packages/language-server

`cypher-language-server`, language server for Cypher query language.
Part of the umbrella project cypher-language-support: https://github.com/neo4j/cypher-language-support

`cypher-language-server` can be installed via `npm`:
```sh
npm i -g @neo4j-cypher/language-server
```
]],
  },
}
