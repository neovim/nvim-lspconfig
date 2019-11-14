# nvim-common-lsp

WIP Common configurations for Language Servers.

This repository aims to be a central location to store configurations for
Language Servers which leverages Neovim's built-in LSP client `vim.lsp` for the
client backbone. The `vim.lsp` implementation is made to be customizable and
greatly extensible, but most users just want to get up and going. This
plugin/library is for those people, although it still let's you customize
things as much as you want in addition to the defaults that this provides.

**NOTE**: Requires current Neovim master as of 2019-11-13

**CONTRIBUTIONS ARE WELCOME!**

There's a lot of language servers in the world, and not enough time.  See
[`lua/common_lsp/texlab.lua`](https://github.com/norcalli/nvim-common-lsp/blob/master/lua/common_lsp/texlab.lua)
and
[`lua/common_lsp/skeleton.lua`](https://github.com/norcalli/nvim-common-lsp/blob/master/lua/common_lsp/skeleton.lua)
for examples and ask me questions in the [Neovim
Gitter](https://gitter.im/neovim/neovim) to help me complete configurations for
*all the LSPs!*

If you don't know where to start, you can pick one that's not in progress or
implemented from [this excellent list compiled by the coc.nvim
contributors](https://github.com/neoclide/coc.nvim/wiki/Language-servers) and
create a new file under `lua/common_lsp/SERVER_NAME.lua`.
- For a simple server which should only ever have one instance for the entire
neovim lifetime, I recommend copying `lua/common_lsp/texlab.lua`.
- For servers which should have a different instance for each project root, I
recommend copying `lua/common_lsp/gopls.lua`.

## Progress

Implemented:
- [gopls](https://github.com/norcalli/nvim-common-lsp#gopls)
- [texlab](https://github.com/norcalli/nvim-common-lsp#texlab)

Planned servers to implement (by me, but contributions welcome anyway):
- [clangd](https://clang.llvm.org/extra/clangd/Installation.html)
- [ccls](https://github.com/MaskRay/ccls)
- [lua-language-server](https://github.com/sumneko/lua-language-server)
- [rust-analyzer](https://github.com/rust-analyzer/rust-analyzer)

In progress:
- ...

## Install

`Plug 'norcalli/nvim-common-lsp'`

## Use

From vim:
```vim
call common_lsp#texlab({})
call common_lsp#gopls({})

" These are still TODO, but will be done.
call common_lsp#clangd({})
call common_lsp#ccls({})
call common_lsp#tsserver({})

" Or using a dynamic name.
call common_lsp#setup("texlab", {})
call common_lsp#setup("gopls", {})
```

From Lua:
```lua
require 'common_lsp'.texlab.setup {
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

local common_lsp = require 'common_lsp'

-- Customize how to find the root_dir
common_lsp.gopls.setup {
  root_dir = common_lsp.util.root_pattern(".git");
}

-- Build the current buffer.
require 'common_lsp'.texlab.buf_build(0)
```

# LSP Implementations

## texlab

https://texlab.netlify.com/

```
common_lsp.texlab.setup({config})
common_lsp#texlab({config})

    A function to set up texlab easier.

    Additionally, it sets up the following commands:
    - `TexlabBuild`: builds the current buffer.

    {config} is the same as |vim.lsp.add_filetype_config()|, but with some
    additions and changes:

    {log_level}
      controls the level of logs to show from build processes and other
      window/logMessage events. By default it is set to
      vim.lsp.protocol.MessageType.Warning instead of
      vim.lsp.protocol.MessageType.Log.

    {settings}
      The settings specified here https://texlab.netlify.com/docs/reference/configuration.
      This is a table, and the keys are case sensitive.
      Example: `settings = { latex = { build = { onSave = true } } }`

    {filetype}
      Defaults to {"tex", "bib"}

    {cmd}
      Defaults to {"texlab"}

    {name}
      Defaults to "texlab"
```

## gopls

https://github.com/golang/tools/tree/master/gopls

```
common_lsp.gopls.setup({config})
common_lsp#gopls({config})

    A function to set up `gopls` easier.
   
    Additionally, it sets up the following commands:
    - SKELETON_SPOOKY_COMMAND: This does something SPOOKY.
   
    {config} is the same as |vim.lsp.add_filetype_config()|, but with some
    additions and changes:
   
    {root_dir}
      REQUIRED function(filename, bufnr) which is called on new candidate
      buffers to attach to and returns either a root_dir or nil.
      If a root_dir is returned, then this file will also be attached. You can
      optionally use {filetype} to help pre-filter by filetype.
      If a root_dir is returned which differs from any previously returned
      root_dir, a new server will be spawned with that root_dir.
      If nil is returned, the buffer is skipped.
 
      See |common_lsp.util.search_ancestors()| and the functions which use it:
      - |common_lsp.util.root_pattern(patterns...)| finds an ancestor which a
      descendent which has one of the files in `patterns...`. This is equivalent
      to coc.nvim's "rootPatterns"
      - More specific utilities:
        - |common_lsp.util.find_git_root()|
        - |common_lsp.util.find_node_modules_root()|
        - |common_lsp.util.find_package_json_root()|
   
      Defaults to common_lsp.util.root_pattern("go.mod", ".git")
   
    {name}
      Defaults to "gopls"
   
    {cmd}
      Defaults to {"gopls"}
   
    {filetype}
      Defaults to {"go"}. This is optional and only serves to reduce the scope
      of files to filter for {root_dir}.
   
    {log_level}
      controls the level of logs to show from build processes and other
      window/logMessage events. By default it is set to
      vim.lsp.protocol.MessageType.Warning instead of
      vim.lsp.protocol.MessageType.Log.
   
    {settings}
      This is a table, and the keys are case sensitive.
      Example: `settings = { }`
```
