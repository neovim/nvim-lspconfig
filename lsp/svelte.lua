-- https://github.com/sveltejs/language-tools/tree/master/packages/language-server
--
-- Note: assuming that [ts_ls](#ts_ls) is setup, full JavaScript/TypeScript support (find references, rename, etc of symbols in Svelte files when working in JS/TS files) requires per-project installation and configuration of [typescript-svelte-plugin](https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin#usage).
--
-- `svelte-language-server` can be installed via `npm`:
-- ```sh
-- npm install -g svelte-language-server
-- ```
return {
  cmd = { 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  root_markers = { 'package.json', '.git' },
}
