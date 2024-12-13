return {
  default_config = {
    cmd = {
      'perl',
      '-MPerl::LanguageServer',
      '-e',
      'Perl::LanguageServer::run',
      '--',
      '--port 13603',
      '--nostdio 0',
    },
    settings = {
      perl = {
        perlCmd = 'perl',
        perlInc = ' ',
        fileFilter = { '.pm', '.pl' },
        ignoreDirs = '.git',
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
https://github.com/richterger/Perl-LanguageServer/tree/master/clients/vscode/perl

`Perl-LanguageServer`, a language server for Perl.

To use the language server, ensure that you have Perl::LanguageServer installed and perl command is on your path.
]],
  },
}
