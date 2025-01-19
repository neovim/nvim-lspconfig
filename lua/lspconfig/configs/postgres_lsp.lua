return {
  default_config = {
    cmd = { 'postgres_lsp' },
    filetypes = { 'sql' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'root-file.txt' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/supabase/postgres_lsp

A Language Server for Postgres
        ]],
  },
}
