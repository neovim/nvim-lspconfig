---@brief
---
--- https://github.com/mickael-menu/zk
---
--- A plain text note-taking assistant

local function find_zk_root(startpath)
  for dir in vim.fs.parents(startpath) do
    if vim.fn.isdirectory(vim.fs.joinpath(dir, '.zk')) == 1 then
      return dir
    end
  end
end

return {
  cmd = { 'zk', 'lsp' },
  filetypes = { 'markdown' },
  root_markers = { '.zk' },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkIndex', function()
      vim.lsp.buf.execute_command {
        command = 'zk.index',
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      }
    end, {
      desc = 'ZkIndex',
    })

    vim.api.nvim_buf_create_user_command(0, 'LspZkList', function()
      local bufpath = vim.api.nvim_buf_get_name(0)
      local root = find_zk_root(bufpath)

      client:exec_cmd({
        command = 'zk.list',
        arguments = { root, { select = { 'path' } } },
      }, { bufnr = bufnr }, function(_err, result)
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
    end, {
      desc = 'ZkList',
    })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkNew', function(...)
      client:exec_cmd({
        command = 'zk.new',
        arguments = {
          vim.api.nvim_buf_get_name(bufnr),
          ...,
        },
      }, { bufnr = bufnr }, function(_err, result)
        if not (result and result.path) then
          return
        end
        vim.cmd('edit ' .. result.path)
      end)
    end, {
      desc = 'ZkNew',
    })
  end,
}
