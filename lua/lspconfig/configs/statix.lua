return {
  default_config = {
    cmd = { 'statix', 'check', '--stdin' },
    filetypes = { 'nix' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'flake.nix', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/nerdypepper/statix

lints and suggestions for the nix programming language
    ]],
  },
}
