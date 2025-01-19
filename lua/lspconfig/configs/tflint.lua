return {
  default_config = {
    cmd = { 'tflint', '--langserver' },
    filetypes = { 'terraform' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.terraform', '.git', '.tflint.hcl' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/terraform-linters/tflint

A pluggable Terraform linter that can act as lsp server.
Installation instructions can be found in https://github.com/terraform-linters/tflint#installation.
]],
  },
}
