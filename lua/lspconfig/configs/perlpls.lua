return {
  default_config = {
    cmd = { 'pls' },
    settings = {
      perl = {
        perlcritic = { enabled = false },
        syntax = { enabled = true },
      },
    },
    filetypes = { 'perl' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/FractalBoy/perl-language-server
https://metacpan.org/pod/PLS

`PLS`, another language server for Perl.

To use the language server, ensure that you have PLS installed and that it is in your path
]],
  },
}
