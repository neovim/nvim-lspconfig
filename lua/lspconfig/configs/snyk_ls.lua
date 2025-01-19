return {
  default_config = {
    cmd = { 'snyk-ls' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git', '.snyk' }, { path = fname, upward = true })[1])
    end,
    filetypes = {
      'go',
      'gomod',
      'javascript',
      'typescript',
      'json',
      'python',
      'requirements',
      'helm',
      'yaml',
      'terraform',
      'terraform-vars',
    },
    single_file_support = true,
    settings = {},
    -- Configuration from https://github.com/snyk/snyk-ls#configuration-1
    init_options = {
      activateSnykCode = 'true',
    },
  },
  docs = {
    description = [[
https://github.com/snyk/snyk-ls

LSP for Snyk Open Source, Snyk Infrastructure as Code, and Snyk Code.
]],
  },
}
