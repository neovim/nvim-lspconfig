local util = require 'lspconfig.util'

local function find_zk_root(startpath)
  for dir in vim.fs.parents(startpath) do
    if vim.fn.isdirectory(vim.fs.joinpath(dir, '.zk')) == 1 then
      return dir
    end
  end
end

return {
  default_config = {
    cmd = { 'zk', 'lsp' },
    filetypes = { 'markdown' },
    root_dir = util.root_pattern '.zk',
  },
  commands = {
    ZkIndex = {
      function()
        vim.lsp.buf.execute_command {
          command = 'zk.index',
          arguments = { vim.api.nvim_buf_get_name(0) },
        }
      end,
      description = 'ZkIndex',
    },
    ZkList = {
      function()
        local bufpath = vim.api.nvim_buf_get_name(0)
        local root = find_zk_root(bufpath)

        vim.lsp.buf_request(0, 'workspace/executeCommand', {
          command = 'zk.list',
          arguments = { root, { select = { 'path' } } },
        }, function(_, result, _, _)
          if not result then
            return
          end
          local paths = vim.tbl_map(function(item)
            return item.path
          end, result)
          vim.ui.select(paths, {}, function(choice)
            vim.cmd('edit ' .. choice)
          end)
        end)
      end,

      description = 'ZkList',
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
  },
}
