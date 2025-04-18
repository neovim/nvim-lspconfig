---@brief
---
--- https://github.com/richterger/Perl-LanguageServer/tree/master/clients/vscode/perl
---
--- `Perl-LanguageServer`, a language server for Perl.
---
--- To use the language server, ensure that you have Perl::LanguageServer installed and perl command is on your path.
return {
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
  root_markers = { '.git' },
}
