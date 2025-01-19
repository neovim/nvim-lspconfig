return {
  default_config = {
    cmd = { 'hh_client', 'lsp' },
    filetypes = { 'php', 'hack' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.hhconfig' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
Language server for programs written in Hack
https://hhvm.com/
https://github.com/facebook/hhvm
See below for how to setup HHVM & typechecker:
https://docs.hhvm.com/hhvm/getting-started/getting-started
    ]],
  },
}
