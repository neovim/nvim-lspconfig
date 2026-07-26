---@brief
---
--- https://github.com/withastro/astro/tree/main/packages/language-tools/language-server
---
--- `astro-ls` can be installed via `npm`:
--- ```sh
--- npm install -g @astrojs/language-server
--- ```
---
--- If typescript is installed globally, you might get the `\`typescript.tsdk\` init option is required` error.
--- You will need to manually pass the typescript SDK path. Here is an example of a Nix configuration where typescript is installed via Nix's Home-manager:
---
--- ```nix
--- { config, pkgs, ... }:
---
--- {
---   home.packages = with pkgs; [
---     typescript
---   ];
---
---   programs.neovim = {
---     plugins = with pkgs.vimPlugins; [
---       nvim-lspconfig
---     ];
---     extraPackages = with pkgs; [
---       astro-language-server
---     ];
---     initLua = ''
---       vim.lsp.config['astro'] = {
---         init_options = {
---           typescript = {
---             tsdk = ${pkgs.typescript}/lib/node_modules/typescript/lib,
---           },
---         },
---       }
---
---       vim.lsp.enable('astro')
---
---       -- ...
---     '';
---   };
--- }
--- ```
--- The path can also be passed via a variable, like `vim.g.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib"` and then used in the Lua Neovim config.
---
--- WARNING: TypeScript 7.x dropped `tsserverlibrary.js` from its npm package, so
--- `typescript.tsdk` cannot resolve from a local or global TS 7.x install. Pin to
--- TS `<= 6.x` (e.g. `npm install -g typescript@~6`) for the LSP to start.
---
--- For a globally-installed TS (resolved at runtime, unlike the Nix example where the
--- path is known at build time), look up the workspace-local TS first via
--- `util.get_typescript_server_path`, then fall back to `npm root -g`:
---
--- ```lua
--- vim.lsp.config('astro', {
---   before_init = function(_, config)
---     local util = require('lspconfig.util')
---     local tsdk = util.get_typescript_server_path(config.root_dir)
---     if tsdk == '' then
---       local npm_root = vim.fn.systemlist('npm root -g')
---       if vim.v.shell_error == 0 and npm_root[1] then
---         tsdk = npm_root[1] .. '/typescript/lib'
---       end
---     end
---     config.init_options = config.init_options or {}
---     config.init_options.typescript = config.init_options.typescript or {}
---     config.init_options.typescript.tsdk = tsdk
---   end,
--- })
--- vim.lsp.enable('astro')
--- ```
---
--- For other package managers, replace `npm root -g` with:
---
--- - pnpm: `pnpm root -g`
--- - yarn classic: `yarn global dir` .. `/node_modules`
--- - yarn berry (>=2): globals unsupported — use a workspace-local TS instead

local util = require 'lspconfig.util'

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'astro-ls'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = { 'astro' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
      config.init_options.typescript.tsdk = util.get_typescript_server_path(config.root_dir)
    end
  end,
}
