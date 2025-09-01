---@brief
--- https://github.com/lttb/gh-actions-language-server
---
--- Language server for GitHub Actions.
---
--- The projects [forgejo](https://forgejo.org/) and [gitea](https://about.gitea.com/)
--- design their actions to be as compatible to github as possible
--- with only [a few differences](https://docs.gitea.com/usage/actions/comparison#unsupported-workflows-syntax) between the systems.
--- The `gh_actions_ls` is therefore enabled for those `yaml` files as well.
---
--- The `gh-actions-language-server` can be installed via `npm`:
---
--- ```sh
--- npm install -g gh-actions-language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'gh-actions-language-server', '--stdio' },
  filetypes = { 'yaml' },

  -- `root_dir` ensures that the LSP does not attach to all yaml files
  root_dir = function(bufnr, on_dir)
    local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    if
      vim.endswith(parent, '/.github/workflows')
      or vim.endswith(parent, '/.forgejo/workflows')
      or vim.endswith(parent, '/.gitea/workflows')
    then
      on_dir(parent)
    end
  end,
  handlers = {
    ['actions/readFile'] = function(_, result)
      if type(result.path) ~= 'string' then
        return nil, nil
      end
      local file_path = vim.uri_to_fname(result.path)
      if vim.fn.filereadable(file_path) == 1 then
        local f = assert(io.open(file_path, 'r'))
        local text = f:read('*a')
        f:close()

        return text, nil
      end
      return nil, nil
    end,
  },
  init_options = {}, -- needs to be present https://github.com/neovim/nvim-lspconfig/pull/3713#issuecomment-2857394868
  capabilities = {
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
    },
  },
}
