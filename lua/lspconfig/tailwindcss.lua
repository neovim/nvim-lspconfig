local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'tailwindcss'
local bin_name = 'tailwindcss-language-server'

configs[server_name] = {
  default_config = {
    cmd = {bin_name, '--stdio'},
    -- filetypes copied and adjusted from tailwindcss-intellisense
    filetypes = {
      -- html
      'aspnetcorerazor',
      'blade',
      'django-html',
      'edge',
      'eelixir', -- vim ft
      'ejs',
      'erb',
      'eruby', -- vim ft
      'gohtml',
      'haml',
      'handlebars',
      'hbs',
      'html',
      -- 'HTML (Eex)',
      -- 'HTML (EEx)',
      'html-eex',
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
    },
    init_options = {
      userLanguages = {
        eelixir = 'html-eex',
        eruby = 'erb',
      },
    },
    root_dir = function(fname)
      return util.root_pattern('tailwind.config.js', 'tailwind.config.ts')(fname) or
      util.root_pattern('postcss.config.js', 'postcss.config.ts')(fname) or
      util.find_package_json_ancestor(fname) or
      util.find_node_modules_ancestor(fname) or
      util.find_git_ancestor(fname)
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/tailwindlabs/tailwindcss-intellisense/master/packages/tailwindcss-language-server/package.json',
    description = [[
https://github.com/tailwindlabs/tailwindcss-intellisense

Tailwind CSS Language Server
]],
    default_config = {
      root_dir = [[root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.ts', 'package.json', 'node_modules', '.git')]],
    },
  },
}
