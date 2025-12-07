---@brief
---
--- https://github.com/wc-toolkit/wc-language-server
---
--- Web Components Language Server provides intelligent editor support for Web Components and custom elements.
--- It offers advanced HTML diagnostics, completion, and validation for custom elements, including support for
--- attribute types, deprecation, and duplicate attribute detection.
---
--- The language server uses the [Custom Elements Manifest](https://github.com/webcomponents/custom-elements-manifest)
--- to generate component integration and validation information
---
--- `wc-language-server` can be installed by following the instructions at the [GitHub repository](https://github.com/wc-toolkit/wc-language-server/blob/main/packages/neovim/README.md).
---
--- The default `cmd` assumes that the `wc-language-server` binary can be found in `$PATH`.
---
--- Alternatively, you can install it via [mason.nvim](https://github.com/williamboman/mason.nvim):
--- ```vim
--- :MasonInstall wc-language-server
--- ```
---
--- ## Configuration
---
--- The language server reads settings from `wc.config.js` (or `.ts/.mjs/.cjs`) at the project root.
--- Use it to customize manifest sources, file scoping, and diagnostic behavior.
---
--- Example `wc.config.js`:
--- ```js
--- export default {
---   // Fetch manifest from a custom path or URL
---   manifestSrc: './dist/custom-elements.json',
---
---   // Narrow which files opt into the language server
---   include: ['src/**/*.ts', 'src/**/*.html'],
---
---   // Skip specific globs
---   exclude: ['**/*.stories.ts'],
---
---   // Per-library overrides
---   libraries: {
---     '@your/pkg': {
---       manifestSrc: 'https://cdn.example.com/custom-elements.json',
---       tagFormatter: (tag) => tag.replace(/^x-/, 'my-'),
---     },
---   },
---
---   // Customize diagnostic severity levels
---   diagnosticSeverity: {
---     duplicateAttribute: 'warning',
---     unknownElement: 'info',
---   },
--- };
--- ```
---
--- See the [configuration documentation](https://github.com/wc-toolkit/wc-language-server#configuration) for more details.
---

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
  root_markers = {
    'wc.config.js',
    'wc.config.ts',
    'wc.config.mjs',
    'wc.config.cjs',
    'custom-elements.json',
    'package.json',
    '.git',
  },
}
