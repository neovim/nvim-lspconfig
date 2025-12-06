---@type vim.lsp.Config
return {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'wc-language-server', '--stdio' },
  filetypes = {
    'html',
    'javascriptreact',
    'typescriptreact',
    'astro',
    'svelte',
    'vue',
    'markdown',
    'mdx',
    'javascript',
    'typescript',
    'css',
    'scss',
    'less',
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = {
      'package-lock.json',
      'yarn.lock',
      'pnpm-lock.yaml',
      'bun.lockb',
      'tsconfig.json',
      'jsconfig.json',
      'wc.config.js',
    }
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
    on_dir(project_root)
  end,
}