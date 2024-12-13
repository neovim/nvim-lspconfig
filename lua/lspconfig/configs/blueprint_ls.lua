return {
  default_config = {
    cmd = { 'blueprint-compiler', 'lsp' },
    cmd_env = {
      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      --
      -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
      GLOB_PATTERN = vim.env.GLOB_PATTERN or '*@(.blp)',
    },
    filetypes = { 'blueprint' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://gitlab.gnome.org/jwestman/blueprint-compiler

`blueprint-compiler` can be installed via your system package manager.

Language server for the blueprint markup language, written in python and part
of the blueprint-compiler.
]],
  },
}
