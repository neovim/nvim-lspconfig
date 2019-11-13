# nvim-common-lsp

WIP Common configurations for Language Servers.

This repository aims to be a central location to store configurations for
Language Servers which leverages Neovim's built-in LSP client `vim.lsp` for the
client backbone. The `vim.lsp` implementation is made to be customizable and
greatly extensible, but most users just want to get up and going. This
plugin/library is for those people, although it still let's you customize
things as much as you want in addition to the defaults that this provides.

**CONTRIBUTIONS ARE WELCOME!**

There's a lot of language servers in the world, and not enough time.  See
[`lua/common_lsp/texlab.lua`](https://github.com/norcalli/nvim-common-lsp/blob/master/lua/common_lsp/texlab.lua)
and
[`lua/common_lsp/skeleton.lua`](https://github.com/norcalli/nvim-common-lsp/blob/master/lua/common_lsp/skeleton.lua)
for examples and ask me questions in the [Neovim
Gitter](https://gitter.im/neovim/neovim) to help me complete configurations for
*all the LSPs!*

## Install

`Plug 'norcalli/nvim-common-lsp'`

## Use

From vim:
```vim
call common_lsp#texlab({})
" These are still TODO, but will be done.
call common_lsp#clangd({})
call common_lsp#ccls({})
call common_lsp#tsserver({})

" Or using a dynamic name.
call common_lsp#setup("texlab", {})
call common_lsp#setup("clangd", {})
```

From Lua:
```lua
require 'common_lsp'.texlab.setup {
  name = "texlab_fancy";
  texlab_log_level = vim.lsp.protocol.MessageType.Log;
  texlab_settings = {
    latex = {
	  build = {
	    onSave = true;
	  }
	}
  }
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

	{texlab_log_level}
	  controls the level of logs to show from build processes and other
	  window/logMessage events. By default it is set to
	  vim.lsp.protocol.MessageType.Warning instead of
	  vim.lsp.protocol.MessageType.Log.

	{texlab_settings}
	  The settings specified here https://texlab.netlify.com/docs/reference/configuration.
	  This is a table, and the keys are case sensitive.
	  Example: `texlab_settings = { latex = { build = { executable = "latexmk" } } }`

	{filetype}
	  Defaults to {"tex", "bib"}

	{cmd}
	  Defaults to {"texlab"}

	{name}
	  Defaults to "texlab"
```
