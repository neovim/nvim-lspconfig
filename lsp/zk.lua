---@brief
---
--- https://github.com/zk-org/zk
---
--- A plain text note-taking assistant

---List notes
---@param client vim.lsp.Client
---@param bufnr integer
---@param opts table
---@param action fun(path: string, title: string)
local function zk_list(client, bufnr, opts, action)
  opts = vim.tbl_extend('keep', { select = { 'path', 'title' } }, opts or {})
  client:exec_cmd({
    title = 'ZkList',
    command = 'zk.list',
    arguments = { vim.api.nvim_buf_get_name(bufnr), opts },
  }, { bufnr = bufnr }, function(err, result)
    if err ~= nil then
      vim.api.nvim_echo({ { 'zk.list error\n' }, { vim.inspect(err) } }, true, {})
      return
    end
    if result == nil then
      return
    end

    vim.ui.select(result, {
      format_item = function(item)
        return item.title
      end,
    }, function(item)
      if item ~= nil then
        action(vim.fs.joinpath(client.root_dir, item.path), item.title)
      end
    end)
  end)
end

---@type vim.lsp.Config
return {
  cmd = { 'zk', 'lsp' },
  filetypes = { 'markdown' },
  root_markers = { '.zk' },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkIndex', function()
      client:exec_cmd({
        title = 'ZkIndex',
        command = 'zk.index',
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      }, { bufnr = bufnr }, function(err, result)
        if err ~= nil then
          vim.api.nvim_echo({ { 'zk.index error\n' }, { vim.inspect(err) } }, true, {})
          return
        end
        if result ~= nil then
          vim.api.nvim_echo({ { vim.inspect(result) } }, false, {})
        end
      end)
    end, { desc = 'ZkIndex' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkList', function()
      zk_list(client, bufnr, {}, function(path)
        vim.cmd('edit ' .. path)
      end)
    end, { desc = 'ZkList' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkTagList', function()
      client:exec_cmd({
        title = 'ZkTagList',
        command = 'zk.tag.list',
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      }, { bufnr = bufnr }, function(err, result)
        if err ~= nil then
          vim.api.nvim_echo({ { 'zk.tag.list error\n' }, { vim.inspect(err) } }, true, {})
          return
        end
        if result == nil then
          return
        end

        vim.ui.select(result, {
          format_item = function(item)
            return item.name
          end,
        }, function(item)
          if item ~= nil then
            zk_list(client, bufnr, { tags = { item.name } }, function(path)
              vim.cmd('edit ' .. path)
            end)
          end
        end)
      end)
    end, { desc = 'ZkTagList' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkNew', function(args)
      local title = #args.fargs >= 1 and args.fargs[1] or ''
      local dir = #args.fargs >= 2 and args.fargs[2] or ''
      client:exec_cmd({
        title = 'ZkNew',
        command = 'zk.new',
        arguments = {
          vim.api.nvim_buf_get_name(bufnr),
          { title = title, dir = dir },
        },
      }, { bufnr = bufnr }, function(err, result)
        if err ~= nil then
          vim.api.nvim_echo({ { 'zk.new error\n' }, { vim.inspect(err) } }, true, {})
          return
        end

        vim.cmd('edit ' .. result.path)
      end)
    end, { desc = 'ZkNew [title] [dir]', nargs = '*' })
  end,
}
