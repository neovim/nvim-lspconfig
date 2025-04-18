---@brief
---
--- https://github.com/FractalBoy/perl-language-server
--- https://metacpan.org/pod/PLS
---
--- `PLS`, another language server for Perl.
---
--- To use the language server, ensure that you have PLS installed and that it is in your path
return {
  cmd = { 'pls' },
  settings = {
    perl = {
      perlcritic = { enabled = false },
      syntax = { enabled = true },
    },
  },
  filetypes = { 'perl' },
  root_markers = { '.git' },
}
