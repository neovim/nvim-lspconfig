return {
  default_config = {
    cmd = { 'opencl-language-server' },
    filetypes = { 'opencl' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/Galarius/opencl-language-server

Build instructions can be found [here](https://github.com/Galarius/opencl-language-server/blob/main/_dev/build.md).

Prebuilt binaries are available for Linux, macOS and Windows [here](https://github.com/Galarius/opencl-language-server/releases).
]],
  },
}
