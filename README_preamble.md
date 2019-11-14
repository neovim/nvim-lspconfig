# nvim-lsp

WIP Common configurations for Language Servers.

This repository aims to be a central location to store configurations for
Language Servers which leverage Neovim's built-in LSP client `vim.lsp` as the
client backbone. The `vim.lsp` implementation is made to be customizable and
greatly extensible, but most users just want to get up and going. This
plugin/library is for those people, although it still lets you customize
things as much as you want in addition to the defaults that this provides.

**NOTE**: Requires current Neovim master as of 2019-11-13

**CONTRIBUTIONS ARE WELCOME!**

There's a lot of language servers in the world, and not enough time.  See
[`lua/nvim_lsp/texlab.lua`](https://github.com/neovim/nvim-lsp/blob/master/lua/nvim_lsp/texlab.lua)
and
[`lua/nvim_lsp/skeleton.lua`](https://github.com/neovim/nvim-lsp/blob/master/lua/nvim_lsp/skeleton.lua)
for examples and ask me questions in the [Neovim
Gitter](https://gitter.im/neovim/neovim) to help me complete configurations for
*all the LSPs!*

If you don't know where to start, you can pick one that's not in progress or
implemented from [this excellent list compiled by the coc.nvim
contributors](https://github.com/neoclide/coc.nvim/wiki/Language-servers) or
[this other excellent list from the emacs lsp-mode
contributors](https://github.com/emacs-lsp/lsp-mode#supported-languages)
and create a new file under `lua/nvim_lsp/SERVER_NAME.lua`. I recommend looking
at `lua/nvim_lsp/texlab.lua` for the most extensive example, but all of them
are good references. Also read `CONTRIBUTING.md`.

## Progress

Implemented:
- [clangd](https://github.com/neovim/nvim-lsp#clangd)
- [gopls](https://github.com/neovim/nvim-lsp#gopls) (has some errors)
- [pyls](https://github.com/neovim/nvim-lsp#pyls)
- [texlab](https://github.com/neovim/nvim-lsp#texlab)
- [elmls](https://github.com/neovim/nvim-lsp#elmls)

Planned servers to implement (by me, but contributions welcome anyway):
- [ccls](https://github.com/MaskRay/ccls)
- [lua-language-server](https://github.com/sumneko/lua-language-server)
- [rust-analyzer](https://github.com/rust-analyzer/rust-analyzer)

In progress:
- ...

## Install

`Plug 'neovim/nvim-lsp'`

## Use

From vim:
```vim
call nvim_lsp#setup("texlab", {})
```

From Lua:
```lua
require 'nvim_lsp'.texlab.setup {
  name = "texlab_fancy";
  log_level = vim.lsp.protocol.MessageType.Log;
  settings = {
    latex = {
      build = {
        onSave = true;
      }
    }
  }
}

local nvim_lsp = require 'nvim_lsp'

-- Customize how to find the root_dir
nvim_lsp.gopls.setup {
  root_dir = nvim_lsp.util.root_pattern(".git");
}

-- Build the current buffer.
require 'nvim_lsp'.texlab.buf_build(0)
```

These are functions to set up servers more easily with some server specific
defaults and more server specific things like commands or different
diagnostics.

Servers may define extra functions on the `nvim_lsp.SERVER` table, e.g.
`nvim_lsp.texlab.buf_build({bufnr})`.

The main setup signature will be:

```
nvim_lsp.SERVER.setup({config})

  {config} is the same as |vim.lsp.start_client()|, but with some
  additions and changes:

  {root_dir}
    May be required (depending on the server).
    `function(filename, bufnr)` which is called on new candidate buffers to
    attach to and returns either a root_dir or nil.

    If a root_dir is returned, then this file will also be attached. You
    can optionally use {filetype} to help pre-filter by filetype.

    If a root_dir is returned which is unique from any previously returned
    root_dir, a new server will be spawned with that root_dir.

    If nil is returned, the buffer is skipped.

    See |nvim_lsp.util.search_ancestors()| and the functions which use it:
    - |nvim_lsp.util.root_pattern(patterns...)| finds an ancestor which
    - contains one of the files in `patterns...`. This is equivalent
    to coc.nvim's "rootPatterns"
    - More specific utilities:
      - |nvim_lsp.util.find_git_root()|
      - |nvim_lsp.util.find_node_modules_root()|
      - |nvim_lsp.util.find_package_json_root()|

  {name}
    Defaults to the server's name.

  {filetypes}
    A set of filetypes to filter for consideration by {root_dir}.
    Can be left empty.
    A server may specify a default value.

  {log_level}
    controls the level of logs to show from build processes and other
    window/logMessage events. By default it is set to
    vim.lsp.protocol.MessageType.Warning instead of
    vim.lsp.protocol.MessageType.Log.

  {settings}
    This is a table, and the keys are case sensitive. This is for the
    window/configuration event responses.
    Example: `settings = { keyName = { subKey = 1 } }`

  {on_attach}
    `function(client)` will be executed with the current buffer as the
    one the {client} is being attaching to. This is different from
    |vim.lsp.start_client()|'s on_attach parameter, which passes the {bufnr} as
    the second parameter instead. This is useful for running buffer local
    commands.

  {on_new_config}
    `function(new_config)` will be executed after a new configuration has been
    created as a result of {root_dir} returning a unique value. You can use this
    as an opportunity to further modify the new_config or use it before it is
    sent to |vim.lsp.start_client()|.
```

# LSP Implementations
