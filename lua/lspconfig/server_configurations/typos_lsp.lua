local util = require 'lspconfig.util'

local root_files = {
  'pyproject.toml',
}

return {
  default_config = {
    cmd = { 'typos-lsp' },
    filetypes = { '*' },
    root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor(),
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/crate-ci/typos
https://github.com/tekumara/typos-vscode

A Language Server Protocol implementation for Typos, a low false-positive
source code spell checker, written in Rust. Download it from the releases page
on GitHub: https://github.com/tekumara/typos-vscode/releases
    ]],
  },
}
