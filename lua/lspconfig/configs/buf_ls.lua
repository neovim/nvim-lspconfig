return {
  default_config = {
    cmd = { 'buf', 'beta', 'lsp', '--timeout=0', '--log-format=text' },
    filetypes = { 'proto' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'buf.yaml', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/bufbuild/buf

buf beta lsp included in the cli itself

buf beta lsp is a Protobuf language server compatible with Buf modules and workspaces
]],
  },
}
