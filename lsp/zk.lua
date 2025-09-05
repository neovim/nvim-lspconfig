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
  }, { bufnr = bufnr }, function(err, result, _)
    if err ~= nil then
      vim.api.nvim_echo({ { 'zk.list error\n' }, { vim.inspect(err) } }, true, {})
      return
    end
    if result == nil then
      return
    end

    local paths = vim.tbl_map(function(item)
      return item.path
    end, result)
    local titles = vim.tbl_map(function(item)
      return item.title
    end, result)
    vim.ui.select(titles, {}, function(item, idx)
      if item ~= nil then
        action(paths[idx], item)
      end
    end)
  end)
end

---@type vim.lsp.Config
return {
  cmd = { 'zk', 'lsp' },
  filetypes = { 'markdown' },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, '.zk')
    if root ~= nil then
      on_dir(root)
    end
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkIndex', function(_)
      client:exec_cmd({
        title = 'ZkIndex',
        command = 'zk.index',
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      }, { bufnr = bufnr }, function(err, result, _)
        if err ~= nil then
          vim.api.nvim_echo({ { 'zk.index error\n' }, { vim.inspect(err) } }, true, {})
          return
        end
        if result ~= nil then
          vim.api.nvim_echo({ { vim.inspect(result) } }, false, {})
        end
      end)
    end, { desc = 'ZkIndex' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkList', function(_)
      zk_list(client, bufnr, {}, function(path, _)
        vim.cmd('edit ' .. path)
      end)
    end, { desc = 'ZkList' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspZkTagList', function(_)
      client:exec_cmd({
        title = 'ZkTagList',
        command = 'zk.tag.list',
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      }, { bufnr = bufnr }, function(err, result, _)
        if err ~= nil then
          vim.api.nvim_echo({ { 'zk.tag.list error\n' }, { vim.inspect(err) } }, true, {})
          return
        end
        if result == nil then
          return
        end

        local tags = vim.tbl_map(function(item)
          return item.name
        end, result)
        vim.ui.select(tags, {}, function(item, _)
          if item ~= nil then
            zk_list(client, bufnr, { tags = { item } }, function(path, _)
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
      }, { bufnr = bufnr }, function(err, result, _)
        if err ~= nil then
          vim.api.nvim_echo({ { 'zk.new error\n' }, { vim.inspect(err) } }, true, {})
          return
        end

        vim.cmd('edit ' .. result.path)
      end)
    end, { desc = 'ZkNew [title] [dir]', nargs = '*' })
  end,
}
