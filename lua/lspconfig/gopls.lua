local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.gopls = {
  default_config = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod' },
    root_dir = function(fname)
      -- First, search for go.work
      local primary_root = util.root_pattern 'go.work'(fname)
      if primary_root then
        return primary_root
      end

      -- Then, search up the filesystem for go.mod direcrory
      local go_mod_hierarchy = {}
      for path in util.path.iterate_parents(fname) do
        for _, p in ipairs(vim.fn.glob(util.path.join(path, 'go.mod'), true, true)) do
          if util.path.exists(p) then
            table.insert(go_mod_hierarchy, p)
          end
        end
      end

      -- Take the top level go.mod
      if #go_mod_hierarchy > 0 then
        return util.path.dirname(go_mod_hierarchy[#go_mod_hierarchy])
      end

      -- Fallback to the git root
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]],
    default_config = {
      root_dir = [[root_pattern("go.mod", ".git")]],
    },
  },
}
