local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'lake', 'serve', '--' },
    filetypes = { 'lean' },
    root_dir = function(fname)
      -- check if inside elan stdlib
      fname = util.path.sanitize(fname)
      local stdlib_dir
      do
        local _, endpos = fname:find '/src/lean'
        if endpos then
          stdlib_dir = fname:sub(1, endpos)
        end
      end
      if not stdlib_dir then
        local _, endpos = fname:find '/lib/lean'
        if endpos then
          stdlib_dir = fname:sub(1, endpos)
        end
      end

      return util.root_pattern('lakefile.toml', 'lakefile.lean', 'lean-toolchain')(fname)
        or stdlib_dir
        or util.find_git_ancestor(fname)
    end,
    on_new_config = function(config, root_dir)
      -- add root dir as command-line argument for `ps aux`
      table.insert(config.cmd, root_dir)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/leanprover/lean4

Lean installation instructions can be found
[here](https://leanprover-community.github.io/get_started.html#regular-install).

The Lean language server is included in any Lean installation and
does not require any additional packages.

Note: that if you're using [lean.nvim](https://github.com/Julian/lean.nvim),
that plugin fully handles the setup of the Lean language server,
and you shouldn't set up `leanls` both with it and `lspconfig`.
    ]],
    default_config = {
      root_dir = [[root_pattern("lakefile.toml", "lakefile.lean", "lean-toolchain", ".git")]],
    },
  },
}
