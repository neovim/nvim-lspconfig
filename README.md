# nvim-lspconfig

nvim-lspconfig is a "data only" repo, providing basic, default [Nvim LSP client](https://neovim.io/doc/user/lsp.html)
configurations for various LSP servers.

View the [documentation for all configs](doc/server_configurations.md) or `:help lspconfig-all` from Nvim.

## Important ⚠️

* If you found a bug in the Nvim LSP functionality (`:help lsp`), [report it to Neovim core](https://github.com/neovim/neovim/issues/new?assignees=&labels=bug%2Clsp&template=lsp_bug_report.yml).
    * **Do not** report it here. Only configuration data lives here.
* These configs are **best-effort and supported by the community.** See [contributions](#contributions).
* **Note:** This repo only provides *configurations*. Its programmatic API is deprecated and should not be used externally.
    * [Work is planned](https://github.com/neovim/neovim/issues/28479) to selectively upstream the
      "framework" parts (*not* the configs) of nvim-lspconfig, to Nvim core, and deprecate them in
      nvim-lspconfig.

## Install

[![LuaRocks](https://img.shields.io/luarocks/v/neovim/nvim-lspconfig?logo=lua&color=purple)](https://luarocks.org/modules/neovim/nvim-lspconfig)

* Requires Nvim 0.10 above. Update Nvim and nvim-lspconfig before reporting an issue.
* Install nvim-lspconfig using Vim's "packages" feature:
  ```
  git clone https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig
  ```
* Or use a 3rd-party plugin manager (consult the documentation for your plugin manager).

## Quickstart

1. Install a language server, e.g. [pyright](doc/server_configurations.md#pyright)
   ```bash
   npm i -g pyright
   ```
2. Add the language server setup to your init.lua.
   ```lua
   require'lspconfig'.pyright.setup{}
   ```
3. Ensure your project/workspace contains a root marker which matches the server requirements
   specified in `:help lspconfig-all`.
4. Open a code file in Nvim. LSP will attach and provide diagnostics.
   ```
   nvim main.py
   ```
5. Run `:checkhealth lsp` to see the status or to troubleshoot.

Read `:help lspconfig` for details. Read `:help lspconfig-all` for the full list of server-specific details.
For servers not on your `$PATH` (e.g., `jdtls`, `elixirls`), you must manually set the `cmd` parameter when calling `setup()`.

## Configuration

Nvim sets some default options and mappings when a buffer attaches to LSP (see [`:help lsp-config`][lsp-config]). In particular:

* [`'tagfunc'`][tagfunc]
    - Enables "go to definition" capabilities using [`<C-]>`][tagjump] and other [tag commands][tag-commands].
* [`'omnifunc'`][omnifunc]
    - Enables (manual) omni mode completion with `<C-X><C-O>` in Insert mode. For *auto*completion, an [autocompletion plugin](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion) is required.
* [`'formatexpr'`][formatexpr]
    - Enables LSP formatting with [`gq`][gq].
* `K` maps to [`vim.lsp.buf.hover()`][vim.lsp.buf.hover] in Normal mode.
* `[d` and `]d` map to `vim.diagnostic.goto_prev()` and `vim.diagnostic.goto_next()`, respectively.
* `<C-W>d` maps to `vim.diagnostic.open_float()`.

[lsp-config]: https://neovim.io/doc/user/lsp.html#lsp-config
[tagfunc]: https://neovim.io/doc/user/tagsrch.html#tag-function
[omnifunc]: https://neovim.io/doc/user/options.html#'omnifunc'
[formatexpr]: https://neovim.io/doc/user/options.html#'formatexpr'
[gq]: https://neovim.io/doc/user/change.html#gq
[vim.lsp.buf.hover]: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.hover()
[tagjump]: https://neovim.io/doc/user/tagsrch.html#CTRL-%5D
[tag-commands]: https://neovim.io/doc/user/tagsrch.html#tag-commands

Further customization can be achieved using the [`LspAttach`][LspAttach] autocommand event.
The [`LspDetach`][LspAttach] autocommand event can be used to "cleanup" mappings if a buffer becomes detached from an LSP server.
See [`:h LspAttach`][LspAttach] and [`:h LspDetach`][LspDetach] for details and examples.
See [`:h lsp-buf`][lsp-buf] for details on other LSP functions.

[LspAttach]: https://neovim.io/doc/user/lsp.html#LspAttach
[LspDetach]: https://neovim.io/doc/user/lsp.html#LspDetach
[lsp-buf]: https://neovim.io/doc/user/lsp.html#lsp-buf

Additional configuration options can be provided for each LSP server by passing arguments to the `setup` function. See `:h lspconfig-setup` for details. Example:

```lua
local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}
```

## Troubleshooting

The most common reasons a language server does not start or attach are:

1. Language server is not installed. nvim-lspconfig does not install language servers for you. You should be able to run the `cmd` defined in each server's Lua module from the command line and see that the language server starts. If the `cmd` is an executable name instead of an absolute path to the executable, ensure it is on your path.
2. Missing filetype plugins. Certain languages are not detecting by Vim/Nvim because they have not yet been added to the filetype detection system. Ensure `:set ft?` shows the filetype and not an empty value.
3. Not triggering root detection. **Some** language servers will only start if it is opened in a directory, or child directory, containing a file which signals the *root* of the project. Most of the time, this is a `.git` folder, but each server defines the root config in the lua file. See [server_configurations.md](doc/server_configurations.md) or the source for the list of root directories.
4. You must pass `capabilities` for **each** `setup {}` if you want these to take effect.
5. **Do not call `setup {}` twice for the same server**. The second call to `setup {}` will overwrite the first.

## Bug reports

If you found a bug with LSP functionality, [report it to Neovim core](https://github.com/neovim/neovim/issues/new?assignees=&labels=bug%2Clsp&template=lsp_bug_report.yml).

Before reporting a bug, check your logs and the output of `:LspInfo`. Add the following to your init.vim to enable logging:

```lua
vim.lsp.set_log_level("debug")
```

Attempt to run the language server, and open the log with:

```
:LspLog
```
Most of the time, the reason for failure is present in the logs.

## Commands

* `:LspInfo` shows the status of active and configured language servers.
* `:LspStart <config_name>` Start the requested server name. Will only successfully start if the command detects a root directory matching the current config. Pass `autostart = false` to your `.setup{}` call for a language server if you would like to launch clients solely with this command. Defaults to all servers matching current buffer filetype.
* `:LspStop <client_id>` Defaults to stopping all buffer clients.
* `:LspRestart <client_id>` Defaults to restarting all buffer clients.

## Contributions

If a language server is missing from [server_configurations.md](doc/server_configurations.md), contributing
a new configuration for it helps others, especially if the server requires special setup. Follow these steps:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
2. Create a new file at `lua/lspconfig/server_configurations/SERVER_NAME.lua`.
    - Copy an [existing config](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/)
      to get started. Most configs are simple. For an extensive example see
      [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/texlab.lua).
3. Ask questions on [GitHub Discussions](https://github.com/neovim/neovim/discussions) or in the [Neovim Matrix room](https://app.element.io/#/room/#neovim:matrix.org).

### Release process

To publish a release:

- Create and push a new [tag](https://github.com/neovim/nvim-lspconfig/tags).
- After pushing the tag, a [GitHub action](./.github/workflows/release.yml)
  will automatically package the plugin and publish the release to LuaRocks.

## License

Copyright Neovim contributors. All rights reserved.

nvim-lspconfig is licensed under the terms of the Apache 2.0 license.

See [LICENSE.md](./LICENSE.md)
