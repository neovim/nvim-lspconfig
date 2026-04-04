---@brief
--- https://github.com/tailwindlabs/tailwindcss-intellisense
---
--- Tailwind CSS Language Server can be installed via npm:
---
--- npm install -g @tailwindcss/language-server
local util = require 'lspconfig.util'

--- Find the first CSS/SCSS/PCSS file containing a Tailwind v4 import directive.
---@return string? path absolute path to the file, or nil if not found
local function find_tailwind_global_css()
  local targets = {
    "@import 'tailwindcss'",
    '@import "tailwindcss"',
  }

  local buf = vim.api.nvim_get_current_buf()
  local root = vim.fs.root(buf, function(name)
    return name == '.git'
  end)

  if not root then
    return nil
  end

  -- Fast path: use git grep to search only tracked + untracked (but not ignored) files
  if vim.fn.executable('git') == 1 then
    local cmd = {
      'git',
      'grep',
      '--untracked',
      '-l',
    }
    for _, target in ipairs(targets) do
      vim.list_extend(cmd, { '-e', target })
    end
    vim.list_extend(cmd, { '--', '*.css', '*.scss', '*.pcss' })

    local result = vim.system(cmd, { cwd = root, text = true }):wait()

    -- git grep found a match
    if result.code == 0 and result.stdout and result.stdout ~= '' then
      local first_match = vim.split(result.stdout, '\n')[1]
      if first_match and first_match ~= '' then
        return root .. '/' .. first_match
      end
    end

    -- git grep ran but found nothing — not a tailwind project, no need for fallback
    if result.code <= 1 then
      return nil
    end
  end

  -- Fallback: scan filesystem, skipping heavy directories (only when git is unavailable)
  local skip_dirs = {
    node_modules = true,
    ['.git'] = true,
    dist = true,
  }

  for name, typ in
    vim.fs.dir(root, {
      depth = math.huge --[[@as integer]],
      skip = function(dir_name)
        -- return false to stop searching the directory
        return not skip_dirs[vim.fs.basename(dir_name)]
      end,
    })
  do
    if typ == 'file' and (name:match('%.css$') or name:match('%.scss$') or name:match('%.pcss$')) then
      local path = root .. '/' .. name
      local ok, content = pcall(vim.fn.readblob, path)
      if ok then
        for _, target in ipairs(targets) do
          if content:find(target, 1, true) then
            return path
          end
        end
      end
    end
  end

  return nil
end

---@type vim.lsp.Config
return {
  cmd = { 'tailwindcss-language-server', '--stdio' },
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
    if not config.settings then
      config.settings = {}
    end
    if not config.settings.editor then
      config.settings.editor = {}
    end
    if not config.settings.editor.tabSize then
      config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
    config.settings.tailwindCSS = config.settings.tailwindCSS or {}
    config.settings.tailwindCSS.experimental = config.settings.tailwindCSS.experimental or {}
    config.settings.tailwindCSS.experimental.configFile = config.settings.tailwindCSS.experimental.configFile
      or find_tailwind_global_css()
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
