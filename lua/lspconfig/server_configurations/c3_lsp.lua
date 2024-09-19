local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'c3lsp' },
    root_dir = function(fname)
      --look for a project directory
      local path = util.root_pattern {'project.json', 'manifest.json'}(fname);
      if path ~= nil then
        return path;
      end

      --look for a library directory
      path = util.root_pattern {"manifest.json"}(fname);
      if path ~= nil then
        return path;
      end

      --look for .git directory
      return util.find_git_ancestors(fname);

    end,
    filetypes = { 'c3', 'c3i' },
  },
  docs = {
    description = [[
https://github.com/pherrymason/c3-lsp

Language Server for c3.
]],
  },
}
