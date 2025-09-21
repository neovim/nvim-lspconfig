# nvim-lspconfig

nvim-lspconfig is a collection of LSP server configurations for the [Nvim LSP client](https://neovim.io/doc/user/lsp.html).

View [all configs](doc/configs.md), or run `:help lspconfig-all` from Nvim.

## Important ⚠️

* `require('lspconfig')` (the legacy "framework" of nvim-lspconfig) [is **deprecated**](https://github.com/neovim/nvim-lspconfig/issues/3693) in favor of [vim.lsp.config](https://neovim.io/doc/user/lsp.html#lsp-config) (Nvim 0.11+).
    * The [lspconfig.lua](./lua/lspconfig.lua) *module* will be dropped. Calls to `require('lspconfig')` will show a warning, which will later become an error.
* nvim-lspconfig itself is **NOT deprecated**. It provides server-specific configs.
    * The configs live in the [lsp/](./lsp/) directory. `vim.lsp.config` automatically finds them and merges them with any local `lsp/*.lua` configs defined by you or a plugin.
    * The old configs in [lua/lspconfig/](./lua/lspconfig/) are **deprecated** and will be removed.

### Migration instructions

1. Upgrade to Nvim 0.11+
2. (Optional) Use `vim.lsp.config('…')` (not `require'lspconfig'.….setup{}`) to *customize* or *define* a config.
3. Use `vim.lsp.enable('…')` (not `require'lspconfig'.….setup{}`) to *enable* a config, so that it activates for its `filetypes`.

## Support

These configs are **best-effort and supported by the community (you).** See [contributions](#contributions).

* Ask questions on [GitHub Discussions](https://github.com/neovim/neovim/discussions), not the issue tracker.
* If you found a bug in Nvim LSP (`:help lsp`), [report it to Neovim core](https://github.com/neovim/neovim/issues/new?assignees=&labels=bug%2Clsp&template=lsp_bug_report.yml).
    * **Do not** report it here. Only configuration data lives here.

## Install

[![LuaRocks](https://img.shields.io/luarocks/v/neovim/nvim-lspconfig?logo=lua&color=purple)](https://luarocks.org/modules/neovim/nvim-lspconfig)

* Requires Nvim 0.11.3+.
    * Support for Nvim 0.10 [will be removed](https://github.com/neovim/nvim-lspconfig/issues/3693). Upgrade Nvim and nvim-lspconfig before reporting an issue.
* Install nvim-lspconfig using Vim's "packages" feature:
  ```
  git clone https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig
  ```
* Or with Nvim 0.12 (nightly), you can use the builtin `vim.pack` plugin manager:
  ```lua
  vim.pack.add{
    { src = 'https://github.com/neovim/nvim-lspconfig' },
  }
  ```
* Or use a 3rd-party plugin manager.

## Quickstart

1. Install a language server, e.g. [pyright](doc/configs.md#pyright)
   ```bash
   npm i -g pyright
   ```
2. Enable its config in your init.lua ([:help lsp-quickstart](https://neovim.io/doc/user/lsp.html#lsp-quickstart)).
   ```lua
   vim.lsp.enable('pyright')
   ```
3. Ensure your project/workspace contains a root marker as specified in `:help lspconfig-all`.
4. Open a code file in Nvim. LSP will attach and provide diagnostics.
   ```
   nvim main.py
   ```
5. Run `:checkhealth vim.lsp` to see the status or to troubleshoot.

See `:help lspconfig-all` for the full list of server-specific details. For
servers not on your `$PATH` (e.g., `jdtls`, `elixirls`), you must manually set
the `cmd` parameter:

```lua
vim.lsp.config('jdtls', {
  cmd = { '/path/to/jdtls' },
})
```

## Configuration

Nvim sets default options and mappings when LSP is active in a buffer:
* [:help lsp-defaults](https://neovim.io/doc/user/lsp.html#lsp-defaults)
* [:help diagnostic-defaults](https://neovim.io/doc/user/diagnostic.html#diagnostic-defaults)

To customize, see:
* [:help lsp-attach](https://neovim.io/doc/user/lsp.html#lsp-attach)
* [:help lsp-buf](https://neovim.io/doc/user/lsp.html#lsp-buf)

Extra settings can be specified for each LSP server. With Nvim 0.11+ you can
[extend a config](https://neovim.io/doc/user/lsp.html#lsp-config) by calling
`vim.lsp.config('…', {…})`. (You can also copy any config directly from
[`lsp/`](./lsp/) and put it in a local `lsp/` directory in your 'runtimepath').

```lua
vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['rust-analyzer'] = {},
  },
})
```

## Create a new config

To create a new config you can either (1) use `vim.lsp.config` or (2) create
a file `lsp/<config-name>.lua` somewhere on your 'runtimepath'.

### Example: define a new config as code

1. Run `:lua vim.lsp.config('foo', {cmd={'true'}})`
2. Run `:lua vim.lsp.enable('foo')`
3. Run `:checkhealth vim.lsp`, the new config is listed under "Enabled Configurations". 😎

### Example: define a new config as a file

1. Create a file `lsp/foo.lua` somewhere on your 'runtimepath'.
   ```
   :exe 'edit' stdpath('config') .. '/lsp/foo.lua'
   ```
2. Add this code to the file (or copy any of the examples from the [lsp/ directory](./lsp/) in this repo):
   ```
   return {
     cmd = { 'true' },
   }
   ```
3. Save the file (with `++p` to ensure its parent directory is created).
   ```
   :write ++p
   ```
4. Enable the config.
   ```
   :lua vim.lsp.enable('foo')
   ```
5. Run `:checkhealth vim.lsp`, the new config is listed under "Enabled Configurations". 🌈

## Troubleshooting

Start with `:checkhealth vim.lsp` to troubleshoot. The most common reasons a language server does not start or attach are:

1. Language server is not installed. nvim-lspconfig does not install language servers for you. You should be able to run the `cmd` defined in the config from the command line and see that the language server starts. If the `cmd` is a name instead of an absolute path, ensure it is on your `$PATH`.
2. Missing filetype plugins. Some languages are not detected by Nvim because they have not yet been added to the filetype detection system. Ensure `:set filetype?` shows the filetype and not an empty value.
3. Not triggering root detection. Some language servers require a "workspace", which is found by looking for an ancestor directory that contains a "root marker". The most common root marker is `.git/`, but each config defines other "root marker" names. Root markers/directories are listed in `:help lspconfig-all`.

   You can also explicitly set a root instead of relying on automatic detection by enabling `'exrc'` and adding an `.nvim.lua` at the desired root dir with the following code:
   ```lua
   vim.lsp.config('<client name>', {
     root_dir = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h'),
   })
   ```
   Note that prior to nvim 0.12 `exrc` file is executed only if it's inside of a cwd where you start `nvim`.

## Bug reports

If you found a bug with LSP functionality, [report it to Neovim core](https://github.com/neovim/neovim/issues/new?assignees=&labels=bug%2Clsp&template=lsp_bug_report.yml).

Before reporting a bug, check your logs and the output of `:checkhealth vim.lsp`. Add this to your init.lua to enable verbose logging:

```lua
vim.lsp.set_log_level("debug")
```

Attempt to run the language server, then run `:LspLog` to open the log.
Most of the time, the reason for failure is present in the logs.

## Commands

* `:LspInfo` (alias to `:checkhealth vim.lsp`) shows the status of active and configured language servers.
* `:LspStart <config_name>` Start the requested server name. Will only successfully start if the command detects a root directory matching the current config.
* `:LspStop [<client_id_or_name>]` Stops the given server. Defaults to stopping all servers active on the current buffer. To force stop add `++force`
* `:LspRestart [<client_id_or_name>]` Restarts the given client, and attempts to reattach to all previously attached buffers. Defaults to restarting all active servers.

## Contributions

If a language server is missing from [configs.md](doc/configs.md), contributing
a new configuration for it helps others, especially if the server requires special setup. Follow these steps:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
2. Create a new file at `lsp/<server_name>.lua`.
    - Copy an [existing config](https://github.com/neovim/nvim-lspconfig/tree/master/lsp)
      to get started. Most configs are simple. For an extensive example see
      [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lsp/texlab.lua).
3. Ask questions on [GitHub Discussions](https://github.com/neovim/neovim/discussions) or in the [Neovim Matrix room](https://app.element.io/#/room/#neovim:matrix.org).

## Release process

To publish a release:

- Create and push a new [tag](https://github.com/neovim/nvim-lspconfig/tags).
- After pushing the tag, a [GitHub action](./.github/workflows/release.yml)
  will automatically package the plugin and publish the release to LuaRocks.

## License

Copyright Neovim contributors. All rights reserved.

nvim-lspconfig is licensed under the terms of the Apache 2.0 license.

See [LICENSE.md](./LICENSE.md)
