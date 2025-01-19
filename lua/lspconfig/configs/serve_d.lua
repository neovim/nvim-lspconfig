return {
  default_config = {
    cmd = { 'serve-d' },
    filetypes = { 'd' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'dub.json', 'dub.sdl', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
           https://github.com/Pure-D/serve-d

           `Microsoft language server protocol implementation for D using workspace-d.`
           Download a binary from https://github.com/Pure-D/serve-d/releases and put it in your $PATH.
        ]],
  },
}
