---@brief
-- https://biomejs.dev
--
-- Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
--
-- ```sh
-- npm install [-g] @biomejs/biome
-- ```

return {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = {
    'astro',
    'css',
    'graphql',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vue',
  },
  root_markers = { 'biome.json', 'biome.jsonc' },
}
