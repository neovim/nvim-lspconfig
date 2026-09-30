---@brief
--- https://github.com/tailwindlabs/tailwindcss-intellisense
---
--- Tailwind CSS Language Server can be installed via npm:
---
--- npm install -g @tailwindcss/language-server
---
--- To manually set the config file or CSS entry-point, see:
--- https://github.com/tailwindlabs/tailwindcss-intellisense#tailwindcssexperimentalconfigfile

local util = require('lspconfig.util')

local function get_cmd(cmd, root_dir)
  if not root_dir then
    return cmd
  end

  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local workspace_root = vim.fs.root(root_dir, lockfiles) or vim.fs.root(root_dir, '.git') or root_dir
  local dir = root_dir
  while dir do
    local local_cmd = vim.fs.joinpath(dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      return local_cmd
    end
    if dir == workspace_root then
      break
    end
    dir = vim.fs.dirname(dir)
  end
  return cmd
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = get_cmd('tailwindcss-language-server', (config or {}).root_dir)
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  -- filetypes copied and adjusted from tailwindcss-intellisense
  filetypes = {
    -- html
    'aspnetcorerazor',
    'astro',
    'astro-markdown',
    'blade',
    'clojure',
    'django-html',
    'htmldjango',
    'edge',
    'eelixir', -- vim ft
    'elixir',
    'ejs',
    'erb',
    'eruby', -- vim ft
    'gohtml',
    'gohtmltmpl',
    'haml',
    'handlebars',
    'hbs',
    'html',
    'htmlangular',
    'html-eex',
    'heex',
    'jade',
    'leaf',
    'liquid',
    'markdown',
    'mdx',
    'mustache',
    'njk',
    'nunjucks',
    'php',
    'razor',
    'slim',
    'twig',
    -- css
    'css',
    'less',
    'postcss',
    'sass',
    'scss',
    'stylus',
    'sugarss',
    -- js
    'javascript',
    'javascriptreact',
    'reason',
    'rescript',
    'typescript',
    'typescriptreact',
    -- mixed
    'vue',
    'svelte',
    'templ',
  },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  ---@type lspconfig.settings.tailwindcss
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = {
        'class',
        'className',
        'class:list',
        'classList',
        'ngClass',
      },
      includeLanguages = {
        eelixir = 'html-eex',
        elixir = 'phoenix-heex',
        eruby = 'erb',
        heex = 'phoenix-heex',
        htmlangular = 'html',
        templ = 'html',
      },
    },
  },
  before_init = function(_, config)
    config.settings = vim.tbl_deep_extend('keep', config.settings, {
      editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
    })
  end,
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_files = {
      -- Generic
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts',
      -- Django
      'theme/static_src/tailwind.config.js',
      'theme/static_src/tailwind.config.cjs',
      'theme/static_src/tailwind.config.mjs',
      'theme/static_src/tailwind.config.ts',
      'theme/static_src/postcss.config.js',
      -- Fallback for tailwind v4, where tailwind.config.* is not required anymore
      '.git',
    }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    root_files = util.insert_package_json(root_files, 'tailwindcss', fname)
    root_files = util.root_markers_with_field(root_files, { 'mix.lock', 'Gemfile.lock' }, 'tailwind', fname)
    on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
  end,
}
