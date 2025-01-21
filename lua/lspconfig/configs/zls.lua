return {
  default_config = {
    cmd = { 'zls' },
    on_new_config = function(new_config, new_root_dir)
      if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, 'zls.json')) ~= 0 then
        new_config.cmd = { 'zls', '--config-path', 'zls.json' }
      end
    end,
    filetypes = { 'zig', 'zir' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'zls.json', 'build.zig', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/zigtools/zls

Zig LSP implementation + Zig Language Server
        ]],
  },
}
