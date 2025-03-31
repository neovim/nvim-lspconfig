---@brief
---
---https://muon.build
return {
  cmd = { 'muon', 'analyze', 'lsp' },
  filetypes = { 'meson' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local cmd = { 'muon', 'analyze', 'root-for', fname }
    vim.system(cmd, { text = true }, function(output)
      if output.code == 0 then
        if output.stdout then
          done_callback(vim.trim(output.stdout))
          return
        end

        done_callback(nil)
      else
        vim.notify(('[muon] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
      end
    end)
  end,
}
