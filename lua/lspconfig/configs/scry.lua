return {
  default_config = {
    cmd = { 'scry' },
    filetypes = { 'crystal' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'shard.yml', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/crystal-lang-tools/scry

Crystal language server.
]],
  },
}
