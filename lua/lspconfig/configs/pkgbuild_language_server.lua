return {
  default_config = {
    cmd = { 'pkgbuild-language-server' },
    filetypes = { 'PKGBUILD' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/Freed-Wu/pkgbuild-language-server

Language server for ArchLinux/Windows Msys2's PKGBUILD.
]],
  },
}
