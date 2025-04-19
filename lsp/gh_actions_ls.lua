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
return {
  cmd = { 'gh-actions-language-server', '--stdio' },
  -- the `root_markers` with `workspace_required` prevent attaching to every yaml file
  filetypes = { 'yaml' },
  root_markers = {
    '.github/workflows',
    '.forgejo/workflows',
    '.gitea/workflows',
  },
  workspace_required = true,
  capabilities = {
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
    },
  },
}
