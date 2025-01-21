return {
  default_config = {
    cmd = { 'gh-actions-language-server', '--stdio' },
    filetypes = { 'yaml' },

    -- Only attach to yaml files that are GitHub workflows instead of all yaml
    -- files. (A nil root_dir and no single_file_support results in the LSP not
    -- attaching.) For details, see #3558
    root_dir = function(filename)
      local patterns = {
        { pattern = '/%.github/workflows/.+%.ya?ml', root = '.github' },
        { pattern = '/%.forgejo/workflows/.+%.ya?ml', root = '.forgejo' },
        { pattern = '/%.gitea/workflows/.+%.ya?ml', root = '.gitea' },
      }

      for _, entry in ipairs(patterns) do
        if filename:find(entry.pattern) then
          local match = vim.fs.find(entry.root, { path = filename, upward = true })[1]
          if match then
            return match
          end
        end
      end

      return nil
    end,

    -- Disabling "single file support" is a hack to avoid enabling this LS for
    -- every random yaml file, so `root_dir()` can control the enablement.
    single_file_support = false,

    capabilities = {
      workspace = {
        didChangeWorkspaceFolders = {
          dynamicRegistration = true,
        },
      },
    },
  },
  docs = {
    description = [[
https://github.com/lttb/gh-actions-language-server

Language server for GitHub Actions.

The projects [forgejo](https://forgejo.org/) and [gitea](https://about.gitea.com/)
design their actions to be as compatible to github as possible
with only [a few differences](https://docs.gitea.com/usage/actions/comparison#unsupported-workflows-syntax) between the systems.
The `gh_actions_ls` is therefore enabled for those `yaml` files as well.

The `gh-actions-language-server` can be installed via `npm`:

```sh
npm install -g gh-actions-language-server
```
]],
  },
}
