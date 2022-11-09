local util = require 'lspconfig.util'

local workspace_markers = { '.zk' }

return {
  default_config = {
    cmd = { 'zk', 'lsp' },
    filetypes = { 'markdown' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  commands = {
    ZkIndex = {
      function()
        vim.lsp.buf.execute_command {
          command = 'zk.index',
          arguments = { vim.api.nvim_buf_get_name(0) },
        }
      end,
      description = 'Index',
    },
    ZkNew = {
      function(...)
        vim.lsp.buf_request(0, 'workspace/executeCommand', {
          command = 'zk.new',
          arguments = {
            vim.api.nvim_buf_get_name(0),
            ...,
          },
        }, function(_, result, _, _)
          if not (result and result.path) then
            return
          end
          vim.cmd('edit ' .. result.path)
        end)
      end,

      description = 'ZkNew',
    },
  },
  docs = {
    description = [[
https://github.com/mickael-menu/zk

A plain text note-taking assistant
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
