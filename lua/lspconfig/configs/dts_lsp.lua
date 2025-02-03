return {
  default_config = {
    name = 'dts_lsp',
    cmd = { 'dts-lsp' },
    filetypes = { 'dts', 'dtsi', 'overlay' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
`dts-lsp` is an LSP for Devicetree files built on top of tree-sitter-devicetree grammar.
Language servers can be used in many editors, such as Visual Studio Code, Emacs
or Vim

Install `dts-lsp` from https://github.com/igor-prusov/dts-lsp and add it to path

`dts-lsp` doesn't require any configuration.

More about Devicetree:
https://www.devicetree.org/
https://docs.zephyrproject.org/latest/build/dts/index.html

]],
  },
}
