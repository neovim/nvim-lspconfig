---@brief
---
--- https://github.com/ThePrimeagen/htmx-lsp
---
--- `htmx-lsp` can be installed via `cargo`:
--- ```sh
--- cargo install htmx-lsp
--- ```
---
--- Lsp is still very much work in progress and experimental. Use at your own risk.
return {
  cmd = { 'htmx-lsp' },
  filetypes = { -- filetypes copied and adjusted from tailwindcss-intellisense
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
  root_markers = { '.git' },
}
