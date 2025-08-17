---@brief
---
--- https://github.com/microsoft/typescript-go
---
--- `typescript-go` is experimental port of the TypeScript compiler (tsc) and language server (tsserver) to the Go programming language.
---
--- `tsgo` can be installed via npm `npm install @typescript/native-preview`.
---
--- ### Monorepo support
---
--- `tsgo` supports monorepos by default. It will automatically find the `tsconfig.json` or `jsconfig.json` corresponding to the package you are working on.
--- This works without the need of spawning multiple instances of `tsgo`, saving memory.
---
--- It is recommended to use the same version of TypeScript in all packages, and therefore have it available in your workspace root. The location of the TypeScript binary will be determined automatically, but only once.
---
return {
  cmd = { 'tsgo', '--lsp', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local project_root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb' }
    local project_root = vim.fs.root(bufnr, project_root_markers)
    if not project_root then
      return nil
    end

    -- We know that the buffer is using Typescript if it has a config file
    -- in its directory tree.
    local ts_config_files = { 'tsconfig.json', 'jsconfig.json' }
    local is_buffer_using_typescript = vim.fs.find(ts_config_files, {
      path = vim.api.nvim_buf_get_name(bufnr),
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_typescript then
      return nil
    end

    on_dir(project_root)
  end,
}
