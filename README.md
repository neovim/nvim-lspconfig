# nvim-lspconfig

Collection of common configurations for Neovim's built-in [language server client](https://neovim.io/doc/user/lsp.html).
The configurations are supported on a best-effort basis, and rely on contributions 
from regular users to stay up-to-date.

This repo handles automatically launching, initializing, and configuring language servers
that are installed on your system.

## Install

* Requires [Neovim HEAD/nightly](https://github.com/neovim/neovim/releases/tag/nightly) (v0.5 prerelease). The configs in this repo
  assume that you are using the latest [Neovim HEAD/nightly build](https://github.com/neovim/neovim/releases/tag/nightly). 
  Update Neovim and nvim-lspconfig before reporting an issue.

* nvim-lspconfig is just a plugin. Install it like any other Vim plugin, e.g. with [vim-plug](https://github.com/junegunn/vim-plug):
  ```
  :Plug 'neovim/nvim-lspconfig'
  ```
## Quickstart
1. Install a language server, e.g. [pyright](CONFIG.md#pyright) via `npm i -g pyright`
2. Install `nvim-lspconfig` via your plugin manager
3. Add the language server setup to your init.vim. The server name must match those found in the table of contents in [CONFIG.md](CONFIG.md)
```vim
lua << EOF 
require'lspconfig'.pyright.setup{}
EOF 
```
4. Open a file that is placed in a directory recognized by the server 
(see server configuration in [CONFIG.md](CONFIG.md); e.g., for [pyright](CONFIG.md#pyright), this is 
any directory containing ".git", "setup.py",  "setup.cfg", "pyproject.toml",
or "requirements.txt")
5. See [Keybindings and completion](#Keybindings-and-completion) for mapping useful functions and enabling
omnifunc completion
6. Try `:LspInfo` to see the status of active and configured language servers.

## Usage

**All provided examples are in Lua,** see `:help :lua-heredoc` to use Lua from your init.vim,
or the quickstart above for an example of a lua heredoc.

Each config provides a `setup()` function to initialize the server with reasonable default
initialization options and settings, as well as some server-specific commands. This is 
invoked in the following form, where `<server>` corresponds to the language server name
in [CONFIG.md](CONFIG.md).

`setup()` takes optional arguments <config>, each of which overrides the respective 
part of the default configuration. The allowed arguments are detailed [below](#setup-function).
```lua
require'lspconfig'.<server>.setup{<config>}
```

### Example: using the defaults

To use the defaults, just call `setup()` with an empty `config` parameter.
For the `gopls` config, that would be:

```lua
require'lspconfig'.gopls.setup{}
```

### Example: override some defaults

To set some config properties at `setup()`, specify their keys. For example to
change how the "project root" is found, set the `root_dir` key:

```lua
local lspconfig = require'lspconfig'
lspconfig.gopls.setup{
  root_dir = lspconfig.util.root_pattern('.git');
}
```

The [documentation](CONFIG.md) for each config lists default values and
additional optional properties. For a more complicated example overriding 
the `name`, `log_level`, `message_level`, and `settings` of texlab:

```lua
local lspconfig = require'lspconfig'
lspconfig.texlab.setup{
  name = 'texlab_fancy';
  log_level = vim.lsp.protocol.MessageType.Log;
  message_level = vim.lsp.protocol.MessageType.Log;
  settings = {
    latex = {
      build = {
        onSave = true;
      }
    }
  }
}
```

### Example: custom config

To configure a custom/private server, just 

1. load the lspconfig module: `local lspconfig = require('lspconfig')`,
2. Define the config: `lspconfig.configs.foo_lsp = { … }`
3. Call `setup()`: `lspconfig.foo_lsp.setup{}`

```lua
local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
configs.foo_lsp = {
  default_config = {
    cmd = {'/home/ashkan/works/3rd/lua-language-server/run.sh'};
    filetypes = {'lua'};
    root_dir = function(fname)
      return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    settings = {};
  };
}
lspconfig.foo_lsp.setup{}
```

### Example: override default config for all servers

If you want to change default configs for all servers, you can override default_config like this.

```lua
local lspconfig = require'lspconfig'
lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  { log_level = lsp.protocol.MessageType.Warning.Error }
)
```

## Individual server settings and initialization options

See [CONFIG.md](CONFIG.md) for documentation and configuration of individual language servers.
This document contains installation instructions for each language server, and is 
auto-generated from the documentation in the lua source. Do not submit PRs 
modifying CONFIG.md directly; CONFIG.md will be overwritten by docgen

**You do not need to copy settings or init_options from this configuration into your config**

## Keybindings and completion

The following maps most of the standard functions to keybindings, and maps omnicomplete to use
the lsp.omnifunc. See `:help lsp` for more details
```vim
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF
```
## The wiki
Please see the [wiki](https://github.com/neovim/nvim-lspconfig/wiki) for additional topics, including:

* [Installing language servers automatically](https://github.com/neovim/nvim-lspconfig/wiki/Installing-language-servers-automatically)
* [Snippets support](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins)
* [Project local settings](https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings)
* [Recommended plugins for enhanced language server features](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins)

and more.

## setup() function

Only the following arguments can be passed to the setup function:

```
lspconfig.SERVER.setup{config}

  The `config` parameter has the same shape as that of
  |vim.lsp.start_client()|, with these additions and changes:

  {root_dir}
    Required for some servers, optional for others.
    Function of the form `function(filename, bufnr)`.
    Called on new candidate buffers being attached-to.
    Returns either a root_dir or nil.

    If a root_dir is returned, then this file will also be attached. You
    can optionally use {filetype} to help pre-filter by filetype.

    If a root_dir is returned which is unique from any previously returned
    root_dir, a new server will be spawned with that root_dir.

    If nil is returned, the buffer is skipped.

    See |lspconfig.util.search_ancestors()| and the functions which use it:
    - |lspconfig.util.root_pattern(pattern1, pattern2...)| is a variadic function which
      takes string patterns as arguments, and finds an ancestor 
      which contains one of the files matching the pattern. 
      Each pattern can be a specific filename, such as ".git", or a glob.  
      See `:help glob` for allowed patterns.  This is equivalent to
      coc.nvim's "rootPatterns"
    - Related utilities for common tools:
      - |lspconfig.util.find_git_root()|
      - |lspconfig.util.find_node_modules_root()|
      - |lspconfig.util.find_package_json_root()|

  {name}
    Defaults to the server's name.

  {filetypes}
    Set of filetypes to filter for consideration by {root_dir}.
    May be empty.
    Server may specify a default value.

  {log_level}
    controls the level of logs to show from window/logMessage notifications. Defaults to
    vim.lsp.protocol.MessageType.Warning instead of
    vim.lsp.protocol.MessageType.Log.

  {message_level}
    controls the level of messages to show from window/showMessage notifications. Defaults to
    vim.lsp.protocol.MessageType.Warning instead of
    vim.lsp.protocol.MessageType.Log.

  {settings}
    Map with case-sensitive keys corresponding to `workspace/configuration`
    event responses.
    We also notify the server *once* on `initialize` with
    `workspace/didChangeConfiguration`.
    If you change the settings later on, you must emit the notification
    with `client.workspace_did_change_configuration({settings})`
    Example: `settings = { keyName = { subKey = 1 } }`

  {on_attach}
    `function(client, bufnr)` Runs the on_attach function from the client's 
    config if it was defined. Useful for doing buffer-local setup.

  {on_new_config}
    `function(new_config, new_root_dir)` will be executed after a new configuration has been
    created as a result of {root_dir} returning a unique value. You can use this
    as an opportunity to further modify the new_config or use it before it is
    sent to |vim.lsp.start_client()|. If you set a custom `on_new_config`, ensure that 
    `new_config.cmd = cmd` is present within the function body.
```

## Debugging
The two most common points of failure are 

1. The language server is not installed. You should be able to run the `cmd` 
defined in each lua module from the command line.

2. Not triggering root detection. The language server will only start if it
is opened in a directory, or child directory, containing a file which signals
the *root* of the project. Most of the time, this is a `.git` folder, but each server
defines the root config in the lua file.

:LspInfo provides a handy overview of your active and configured language servers.
Note, that it will not report any configuration changes applied in `on_new_config`.

Before reporting a bug, check your logs and the output of `:LspInfo`. Add the 
following to your init.vim to enable logging 

```vim
lua << EOF
vim.lsp.set_log_level("debug")
EOF
```
Attempt to run the language server, and open the log with:
```
:lua vim.cmd('e'..vim.lsp.get_log_path())
```
Most of the time, the reason for failure is present in the logs.

## Contributions
If you are missing a language server on the list in [CONFIG.md](CONFIG.md), contributing
a new configuration for it would be appreciated. You can follow these steps:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
2. Choose a language from [the coc.nvim wiki](https://github.com/neoclide/coc.nvim/wiki/Language-servers) or
  [emacs-lsp](https://github.com/emacs-lsp/lsp-mode#supported-languages).
3. Create a new file at `lua/lspconfig/SERVER_NAME.lua`.
   - Copy an [existing config](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/)
     to get started. Most configs are simple. For an extensive example see
     [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/texlab.lua).
4. Ask questions in [Neovim Gitter](https://gitter.im/neovim/neovim).
