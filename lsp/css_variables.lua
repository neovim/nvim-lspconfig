---@brief
---
--- https://github.com/vunguyentuan/vscode-css-variables/tree/master/packages/css-variables-language-server
---
--- CSS variables autocompletion and go-to-definition
---
--- `css-variables-language-server` can be installed via `npm`:
---
--- ```sh
--- npm i -g css-variables-language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'css-variables-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },

  -- Taken from lsp/ts_ls.lua to handle simple projects and monorepos.
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has 'nvim-0.11.3' == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })
    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,

  -- Same as inlined defaults that don't seem to work without hardcoding them in the lua config
  -- https://github.com/vunguyentuan/vscode-css-variables/blob/763a564df763f17aceb5f3d6070e0b444a2f47ff/packages/css-variables-language-server/src/CSSVariableManager.ts#L31-L50
  settings = {
    cssVariables = {
      lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
      blacklistFolders = {
        '**/.cache',
        '**/.DS_Store',
        '**/.git',
        '**/.hg',
        '**/.next',
        '**/.svn',
        '**/bower_components',
        '**/CVS',
        '**/dist',
        '**/node_modules',
        '**/tests',
        '**/tmp',
      },
    },
  },
}
