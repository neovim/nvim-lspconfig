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
[`lua/nvim_lsp/*.lua`](https://github.com/neovim/nvim-lsp/blob/master/lua/nvim_lsp/)
for examples and ask us questions in the [Neovim
Gitter](https://gitter.im/neovim/neovim) to help us complete configurations for
*all the LSPs!* Read `CONTRIBUTING.md` for some instructions. NOTE: don't
modify `README.md`; it is auto-generated.

If you don't know where to start, you can pick one that's not in progress or
implemented from [this excellent list compiled by the coc.nvim
contributors](https://github.com/neoclide/coc.nvim/wiki/Language-servers) or
[this other excellent list from the emacs lsp-mode
contributors](https://github.com/emacs-lsp/lsp-mode#supported-languages)
and create a new file under `lua/nvim_lsp/SERVER_NAME.lua`. We recommend
looking at `lua/nvim_lsp/texlab.lua` for the most extensive example, but all of
them are good references.

## Progress

Implemented language servers:
- [bashls](#bashls)
- [ccls](#ccls)
- [clangd](#clangd)
- [cssls](#cssls)
- [elmls](#elmls)
- [flow](#flow)
- [fortls](#fortls)
- [gopls](#gopls)
- [hie](#hie)
- [leanls](#leanls)
- [pyls](#pyls)
- [rls](#rls)
- [solargraph](#solargraph)
- [sumneko_lua](#sumneko_lua)
- [texlab](#texlab)
- [tsserver](#tsserver)

Planned servers to implement (by me, but contributions welcome anyway):
- [lua-language-server](https://github.com/sumneko/lua-language-server)
- [rust-analyzer](https://github.com/rust-analyzer/rust-analyzer)

In progress:
- ...

## Install

`Plug 'neovim/nvim-lsp'`

## Usage

Servers configurations can be set up with a "setup function." These are
functions to set up servers more easily with some server specific defaults and
more server specific things like commands or different diagnostics.

The "setup functions" are `call nvim_lsp#setup({name}, {config})` from vim and
`nvim_lsp[name].setup(config)` from Lua.

Servers may define extra functions on the `nvim_lsp.SERVER` table, e.g.
`nvim_lsp.texlab.buf_build({bufnr})`.

### Auto Installation

Many servers can be automatically installed with the `:LspInstall`
command. Detailed installation info can be found
with the `:LspInstallInfo` command, which optionally accepts a specific server name.

For example:
```vim
LspInstall elmls
silent LspInstall elmls " useful if you want to autoinstall in init.vim
LspInstallInfo
LspInstallInfo elmls
```

### Example

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

### Setup function details

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
    `workspace/configuration` event responses.
    We also notify the server *once* on `initialize` with
    `workspace/didChangeConfiguration`.
    If you change the settings later on, you should send the notification
    yourself with `client.workspace_did_change_configuration({settings})`
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

## bashls

https://github.com/mads-hartmann/bash-language-server

Language server for bash, written using tree sitter in typescript.

Can be installed in neovim with `:LspInstall bashls`

```lua
nvim_lsp.bashls.setup({config})
nvim_lsp#setup("bashls", {config})

  Default Values:
    cmd = { "bash-language-server", "start" }
    filetypes = { "sh" }
    log_level = 2
    root_dir = vim's starting directory
    settings = {}
```

## ccls

https://github.com/MaskRay/ccls/wiki

ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.

This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`ccls.cache.directory`**: `string`

  Default: `".ccls-cache"`
  
  Absolute or relative (from the project root) path to the directory that the cached index will be stored in. Try to have this directory on an SSD. If empty, cached indexes will not be saved on disk.
  
  ${workspaceFolder} will be replaced by the folder where .vscode/settings.json resides.
  
  Cache directories are project-wide, so this should be configured in the workspace settings so multiple indexes do not clash.
  
  Example value: "/work/ccls-cache/chrome/"

- **`ccls.cache.hierarchicalPath`**: `boolean`

  If false, store cache files as $directory/@a@b/c.cc.blob
  
  If true, $directory/a/b/c.cc.blob.

- **`ccls.callHierarchy.qualified`**: `boolean`

  Default: `true`
  
  If true, use qualified names in the call hiearchy

- **`ccls.clang.excludeArgs`**: `array`

  Default: `{}`
  
  An set of command line arguments to strip before passing to clang when indexing. Each list entry is a separate argument.

- **`ccls.clang.extraArgs`**: `array`

  Default: `{}`
  
  An extra set of command line arguments to give clang when indexing. Each list entry is a separate argument.

- **`ccls.clang.pathMappings`**: `array`

  Default: `{}`
  
  Translate paths in compile_commands.json entries, .ccls options and cache files. This allows to reuse cache files built otherwhere if the source paths are different.

- **`ccls.clang.resourceDir`**: `string`

  Default: `""`
  
  Default value to use for clang -resource-dir argument. This will be automatically supplied by ccls if not provided.

- **`ccls.codeLens.enabled`**: `boolean`

  Default: `true`
  
  Specifies whether the references CodeLens should be shown.

- **`ccls.codeLens.localVariables`**: `boolean`

  Set to false to hide code lens on parameters and function local variables.

- **`ccls.codeLens.renderInline`**: `boolean`

  Enables a custom code lens renderer so code lens are displayed inline with code. This removes any vertical-space footprint at the cost of horizontal space.

- **`ccls.completion.caseSensitivity`**: `integer`

  Default: `2`
  
  Case sensitivity when code completion is filtered. 0: case-insensitive, 1: case-folded, i.e. insensitive if no input character is uppercase, 2: case-sensitive

- **`ccls.completion.detailedLabel`**: `boolean`

  When this option is enabled, the completion item label is very detailed, it shows the full signature of the candidate.

- **`ccls.completion.duplicateOptional`**: `boolean`

  For functions with default arguments, generate one more item per default argument.

- **`ccls.completion.enableSnippetInsertion`**: `boolean`

  If true, parameter declarations are inserted as snippets in function/method call arguments when completing a function/method call

- **`ccls.completion.include.blacklist`**: `array`

  Default: `{}`
  
  ECMAScript regex that checks absolute path. If it partially matches, the file is not added to include path auto-complete. An example is "/CACHE/"

- **`ccls.completion.include.maxPathSize`**: `integer`

  Default: `37`
  
  Maximum length for path in #include proposals. If the path length goes beyond this number it will be elided. Set to 0 to always display the full path.

- **`ccls.completion.include.suffixWhitelist`**: `array`

  Default: `{ ".h", ".hpp", ".hh" }`
  
  Only files ending in one of these values will be shown in include auto-complete. Set to the empty-list to disable include auto-complete.

- **`ccls.completion.include.whitelist`**: `array`

  Default: `{}`
  
  ECMAScript regex that checks absolute file path. If it does not partially match, the file is not added to include path auto-complete. An example is "/src/"

- **`ccls.diagnostics.blacklist`**: `array`

  Default: `{}`
  
  Files that match these patterns won't be displayed in diagnostics view.

- **`ccls.diagnostics.onChange`**: `integer`

  Default: `1000`
  
  Time in milliseconds to wait before computing diagnostics on type. -1: disable diagnostics on type.

- **`ccls.diagnostics.onOpen`**: `integer`

  Default: `0`
  
  Time in milliseconds to wait before computing diagnostics when a file is opened.

- **`ccls.diagnostics.onSave`**: `integer`

  Default: `0`
  
  Time in milliseconds to wait before computing diagnostics when a file is saved.

- **`ccls.diagnostics.spellChecking`**: `boolean`

  Default: `true`
  
  Whether to do spell checking on undefined symbol names when computing diagnostics.

- **`ccls.diagnostics.whitelist`**: `array`

  Default: `{}`
  
  Files that match these patterns will be displayed in diagnostics view.

- **`ccls.highlight.blacklist`**: `array|null`

  Default: `vim.NIL`
  
  Files that match these patterns won't have semantic highlight.

- **`ccls.highlight.enum.face`**: `array`

  Default: `{ "variable", "member" }`

- **`ccls.highlight.function.colors`**: `array`

  Default: `{ "#e5b124", "#927754", "#eb992c", "#e2bf8f", "#d67c17", "#88651e", "#e4b953", "#a36526", "#b28927", "#d69855" }`
  
  Colors to use for semantic highlight. A good generator is http://tools.medialab.sciences-po.fr/iwanthue/. If multiple colors are specified, semantic highlight will cycle through them for successive symbols.

- **`ccls.highlight.function.face`**: `array`

  Default: `{}`

- **`ccls.highlight.global.face`**: `array`

  Default: `{ "fontWeight: bolder" }`

- **`ccls.highlight.globalVariable.face`**: `array`

  Default: `{ "variable", "global" }`

- **`ccls.highlight.largeFileSize`**: `integer|null`

  Default: `vim.NIL`
  
  Disable semantic highlight for files larger than the size.

- **`ccls.highlight.macro.colors`**: `array`

  Default: `{ "#e79528", "#c5373d", "#e8a272", "#d84f2b", "#a67245", "#e27a33", "#9b4a31", "#b66a1e", "#e27a71", "#cf6d49" }`
  
  Colors to use for semantic highlight. A good generator is http://tools.medialab.sciences-po.fr/iwanthue/. If multiple colors are specified, semantic highlight will cycle through them for successive symbols.

- **`ccls.highlight.macro.face`**: `array`

  Default: `{ "variable" }`

- **`ccls.highlight.member.face`**: `array`

  Default: `{ "fontStyle: italic" }`

- **`ccls.highlight.memberFunction.face`**: `array`

  Default: `{ "function", "member" }`

- **`ccls.highlight.memberVariable.face`**: `array`

  Default: `{ "variable", "member" }`

- **`ccls.highlight.namespace.colors`**: `array`

  Default: `{ "#429921", "#58c1a4", "#5ec648", "#36815b", "#83c65d", "#417b2f", "#43cc71", "#7eb769", "#58bf89", "#3e9f4a" }`
  
  Colors to use for semantic highlight. A good generator is http://tools.medialab.sciences-po.fr/iwanthue/. If multiple colors are specified, semantic highlight will cycle through them for successive symbols.

- **`ccls.highlight.namespace.face`**: `array`

  Default: `{ "type" }`

- **`ccls.highlight.parameter.face`**: `array`

  Default: `{ "variable" }`

- **`ccls.highlight.static.face`**: `array`

  Default: `{ "fontWeight: bold" }`

- **`ccls.highlight.staticMemberFunction.face`**: `array`

  Default: `{ "function", "static" }`

- **`ccls.highlight.staticMemberVariable.face`**: `array`

  Default: `{ "variable", "static" }`

- **`ccls.highlight.staticVariable.face`**: `array`

  Default: `{ "variable", "static" }`

- **`ccls.highlight.type.colors`**: `array`

  Default: `{ "#e1afc3", "#d533bb", "#9b677f", "#e350b6", "#a04360", "#dd82bc", "#de3864", "#ad3f87", "#dd7a90", "#e0438a" }`
  
  Colors to use for semantic highlight. A good generator is http://tools.medialab.sciences-po.fr/iwanthue/. If multiple colors are specified, semantic highlight will cycle through them for successive symbols.

- **`ccls.highlight.type.face`**: `array`

  Default: `{}`

- **`ccls.highlight.typeAlias.face`**: `array`

  Default: `{ "type" }`

- **`ccls.highlight.variable.colors`**: `array`

  Default: `{ "#587d87", "#26cdca", "#397797", "#57c2cc", "#306b72", "#6cbcdf", "#368896", "#3ea0d2", "#48a5af", "#7ca6b7" }`
  
  Colors to use for semantic highlight. A good generator is http://tools.medialab.sciences-po.fr/iwanthue/. If multiple colors are specified, semantic highlight will cycle through them for successive symbols.

- **`ccls.highlight.variable.face`**: `array`

  Default: `{}`

- **`ccls.highlight.whitelist`**: `array|null`

  Default: `vim.NIL`
  
  Files that match these patterns will have semantic highlight.

- **`ccls.index.blacklist`**: `array`

  Default: `{}`
  
  A translation unit (cc/cpp file) is not indexed if any of the ECMAScript regexes in this list partially matches translation unit's the absolute path.

- **`ccls.index.initialBlacklist`**: `array`

  Default: `{}`
  
  Files matched by the regexes should not be indexed on initialization. Indexing is deferred to when they are opened.

- **`ccls.index.initialWhitelist`**: `array`

  Default: `{}`
  
  Files matched by the regexes should be indexed on initialization.

- **`ccls.index.maxInitializerLines`**: `integer`

  Default: `15`
  
  Number of lines of the initializer / macro definition showed in hover.

- **`ccls.index.multiVersion`**: `integer`

  Default: `0`
  
  If not 0, a file will be indexed in each tranlation unit that includes it.

- **`ccls.index.onChange`**: `boolean`

  Allow indexing on textDocument/didChange. May be too slow for big projects, so it is off by default.

- **`ccls.index.threads`**: `number`

  Default: `0`
  
  Number of indexer threads. If 0, 80% of cores are used.

- **`ccls.index.trackDependency`**: `integer`

  Default: `2`
  
  Whether to reparse a file if write times of its dependencies have changed. The file will always be reparsed if its own write time changes.
  
  0: no, 1: only during initial load of project, 2: yes

- **`ccls.index.whitelist`**: `array`

  Default: `{}`
  
  If a translation unit's absolute path partially matches any ECMAScript regex in this list, it will be indexed. The whitelist takes priority over the blacklist. To only index files in the whitelist, make "ccls.index.blacklist" match everything, ie, set it to ".*".

- **`ccls.launch.args`**: `array`

  Default: `{}`
  
  Array containing extra arguments to pass to the ccls binary

- **`ccls.launch.command`**: `string`

  Default: `"ccls"`
  
  Path to the ccls binary (default assumes the binary is in the PATH)

- **`ccls.misc.compilationDatabaseCommand`**: `string`

  Default: `""`
  
  If not empty, the compilation database command to use

- **`ccls.misc.compilationDatabaseDirectory`**: `string`

  Default: `""`
  
  If not empty, the compilation database directory to use instead of the project root

- **`ccls.misc.showInactiveRegions`**: `boolean`

  Default: `true`
  
  If true, ccls will highlight skipped ranges.

- **`ccls.statusUpdateInterval`**: `integer`

  Default: `2000`
  
  Interval between updating ccls status in milliseconds. Set to 0 to disable.

- **`ccls.theme.dark.skippedRange.backgroundColor`**: `string`

  Default: `"rgba(18, 18, 18, 0.3)"`
  
  CSS color to apply to the background when the code region has been disabled by the preprocessor in a dark theme.

- **`ccls.theme.dark.skippedRange.textColor`**: `string`

  Default: `"rgb(100, 100, 100)"`
  
  CSS color to apply to text when the code region has been disabled by the preprocessor in a dark theme.

- **`ccls.theme.light.skippedRange.backgroundColor`**: `string`

  Default: `"rgba(220, 220, 220, 0.3)"`
  
  CSS color to apply to the background when the code region has been disabled by the preprocessor in a light theme.

- **`ccls.theme.light.skippedRange.textColor`**: `string`

  Default: `"rgb(100, 100, 100)"`
  
  CSS color to apply to text when the code region has been disabled by the preprocessor in a light theme.

- **`ccls.trace.websocketEndpointUrl`**: `string`

  Default: `""`
  
  When set, logs all LSP messages to specified WebSocket endpoint.

- **`ccls.treeViews.doubleClickTimeoutMs`**: `number`

  Default: `500`
  
  If a tree view entry is double-clicked within this timeout value, vscode will navigate to the entry.

- **`ccls.workspaceSymbol.caseSensitivity`**: `integer`

  Default: `1`
  
  Case sensitivity when searching workspace symbols. 0: case-insensitive, 1: case-folded, i.e. insensitive if no input character is uppercase, 2: case-sensitive

- **`ccls.workspaceSymbol.maxNum`**: `number|null`

  Default: `vim.NIL`
  
  The maximum number of global search (ie, Ctrl+P + #foo) search results to report. For small search strings on large projects there can be a massive number of results (ie, over 1,000,000) so this limit is important to avoid extremely long delays. null means use the default value provided by the ccls language server.

</details>

```lua
nvim_lsp.ccls.setup({config})
nvim_lsp#setup("ccls", {config})

  Default Values:
    capabilities = default capabilities, with offsetEncoding utf-8
    cmd = { "ccls" }
    filetypes = { "c", "cpp", "objc", "objcpp" }
    log_level = 2
    on_init = function to handle changing offsetEncoding
    root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git")
    settings = {}
```

## clangd

https://clang.llvm.org/extra/clangd/Installation.html

**NOTE:** Clang >= 9 is recommended! See [this issue for more](https://github.com/neovim/nvim-lsp/issues/23).

clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.


```lua
nvim_lsp.clangd.setup({config})
nvim_lsp#setup("clangd", {config})

  Default Values:
    capabilities = default capabilities, with offsetEncoding utf-8
    cmd = { "clangd", "--background-index" }
    filetypes = { "c", "cpp", "objc", "objcpp" }
    log_level = 2
    on_init = function to handle changing offsetEncoding
    root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git")
    settings = {}
```

## cssls

https://github.com/vscode-langservers/vscode-css-languageserver-bin

`css-languageserver` can be installed via `:LspInstall cssls` or by yourself with `npm`:
```sh
npm install -g vscode-css-languageserver-bin
```

Can be installed in neovim with `:LspInstall cssls`

```lua
nvim_lsp.cssls.setup({config})
nvim_lsp#setup("cssls", {config})

  Default Values:
    capabilities = default capabilities, with offsetEncoding utf-8
    cmd = { "css-languageserver", "--stdio" }
    filetypes = { "css", "scss", "less" }
    log_level = 2
    on_init = function to handle changing offsetEncoding
    root_dir = root_pattern("package.json")
    settings = {
      css = {
        validate = true
      },
      less = {
        validate = true
      },
      scss = {
        validate = true
      }
    }
```

## elmls

https://github.com/elm-tooling/elm-language-server#installation

If you don't want to use neovim to install it, then you can use:
```sh
npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
```

Can be installed in neovim with `:LspInstall elmls`

```lua
nvim_lsp.elmls.setup({config})
nvim_lsp#setup("elmls", {config})

  Default Values:
    capabilities = default capabilities, with offsetEncoding utf-8
    cmd = { "elm-language-server" }
    filetypes = { "elm" }
    init_options = {
      elmAnalyseTrigger = "change",
      elmFormatPath = "elm-format",
      elmPath = "elm",
      elmTestPath = "elm-test"
    }
    log_level = 2
    on_init = function to handle changing offsetEncoding
    root_dir = root_pattern("elm.json")
    settings = {}
```

## flow

https://flow.org/
https://github.com/facebook/flow

See below for how to setup Flow itself.
https://flow.org/en/docs/install/

See below for lsp command options.

```sh
npm run flow lsp -- --help
```
    

```lua
nvim_lsp.flow.setup({config})
nvim_lsp#setup("flow", {config})

  Default Values:
    cmd = { "npm", "run", "flow", "lsp" }
    filetypes = { "javascript", "javascriptreact", "javascript.jsx" }
    log_level = 2
    root_dir = root_pattern(".flowconfig")
    settings = {}
```

## fortls

https://github.com/hansec/fortran-language-server

Fortran Language Server for the Language Server Protocol
    

```lua
nvim_lsp.fortls.setup({config})
nvim_lsp#setup("fortls", {config})

  Default Values:
    cmd = { "fortls" }
    filetypes = { "fortran" }
    log_level = 2
    root_dir = root_pattern(".fortls")
    settings = {
      nthreads = 1
    }
```

## gopls

https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.


```lua
nvim_lsp.gopls.setup({config})
nvim_lsp#setup("gopls", {config})

  Default Values:
    cmd = { "gopls" }
    filetypes = { "go" }
    log_level = 2
    root_dir = root_pattern("go.mod", ".git")
    settings = {}
```

## hie

https://github.com/haskell/haskell-ide-engine

the following init_options are supported (see https://github.com/haskell/haskell-ide-engine#configuration):
```lua
init_options = {
  languageServerHaskell = {
    hlintOn = bool;
    maxNumberOfProblems = number;
    diagnosticsDebounceDuration = number;
    liquidOn = bool (default false);
    completionSnippetsOn = bool (default true);
    formatOnImportOn = bool (default true);
    formattingProvider = string (default "brittany", alternate "floskell");
  }
}
```
        

```lua
nvim_lsp.hie.setup({config})
nvim_lsp#setup("hie", {config})

  Default Values:
    cmd = { "hie-wrapper" }
    filetypes = { "haskell" }
    log_level = 2
    root_dir = root_pattern("stack.yaml", "package.yaml", ".git")
    settings = {}
```

## leanls

https://github.com/leanprover/lean-client-js/tree/master/lean-language-server

Lean language server.
    

```lua
nvim_lsp.leanls.setup({config})
nvim_lsp#setup("leanls", {config})

  Default Values:
    cmd = { "lean-language-server", "--stdio" }
    filetypes = { "lean" }
    log_level = 2
    root_dir = util.root_pattern(".git")
    settings = {}
```

## pyls

https://github.com/palantir/python-language-server

`python-language-server`, a language server for Python.
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`pyls.configurationSources`**: `array`

  Default: `{ "pycodestyle" }`
  
  Array items: `{enum = { "pycodestyle", "pyflakes" },type = "string"}`
  
  List of configuration sources to use.

- **`pyls.executable`**: `string`

  Default: `"pyls"`
  
  Language server executable

- **`pyls.plugins.jedi.environment`**: `string`

  Default: `vim.NIL`
  
  Define environment for jedi.Script and Jedi.names.

- **`pyls.plugins.jedi.extra_paths`**: `array`

  Default: `{}`
  
  Define extra paths for jedi.Script.

- **`pyls.plugins.jedi_completion.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.jedi_completion.include_params`**: `boolean`

  Default: `true`
  
  Auto-completes methods and classes with tabstops for each parameter.

- **`pyls.plugins.jedi_definition.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.jedi_definition.follow_builtin_imports`**: `boolean`

  Default: `true`
  
  If follow_imports is True will decide if it follow builtin imports.

- **`pyls.plugins.jedi_definition.follow_imports`**: `boolean`

  Default: `true`
  
  The goto call will follow imports.

- **`pyls.plugins.jedi_hover.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.jedi_references.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.jedi_signature_help.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.jedi_symbols.all_scopes`**: `boolean`

  Default: `true`
  
  If True lists the names of all scopes instead of only the module namespace.

- **`pyls.plugins.jedi_symbols.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.mccabe.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.mccabe.threshold`**: `number`

  Default: `15`
  
  The minimum threshold that triggers warnings about cyclomatic complexity.

- **`pyls.plugins.preload.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.preload.modules`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  List of modules to import on startup

- **`pyls.plugins.pycodestyle.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.pycodestyle.exclude`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Exclude files or directories which match these patterns.

- **`pyls.plugins.pycodestyle.filename`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  When parsing directories, only check filenames matching these patterns.

- **`pyls.plugins.pycodestyle.hangClosing`**: `boolean`

  Default: `vim.NIL`
  
  Hang closing bracket instead of matching indentation of opening bracket's line.

- **`pyls.plugins.pycodestyle.ignore`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Ignore errors and warnings

- **`pyls.plugins.pycodestyle.maxLineLength`**: `number`

  Default: `vim.NIL`
  
  Set maximum allowed line length.

- **`pyls.plugins.pycodestyle.select`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Select errors and warnings

- **`pyls.plugins.pydocstyle.addIgnore`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Ignore errors and warnings in addition to the specified convention.

- **`pyls.plugins.pydocstyle.addSelect`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Select errors and warnings in addition to the specified convention.

- **`pyls.plugins.pydocstyle.convention`**: `enum { "pep257", "numpy" }`

  Default: `vim.NIL`
  
  Choose the basic list of checked errors by specifying an existing convention.

- **`pyls.plugins.pydocstyle.enabled`**: `boolean`

  Enable or disable the plugin.

- **`pyls.plugins.pydocstyle.ignore`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Ignore errors and warnings

- **`pyls.plugins.pydocstyle.match`**: `string`

  Default: `"(?!test_).*\\.py"`
  
  Check only files that exactly match the given regular expression; default is to match files that don't start with 'test_' but end with '.py'.

- **`pyls.plugins.pydocstyle.matchDir`**: `string`

  Default: `"[^\\.].*"`
  
  Search only dirs that exactly match the given regular expression; default is to match dirs which do not begin with a dot.

- **`pyls.plugins.pydocstyle.select`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Select errors and warnings

- **`pyls.plugins.pyflakes.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.pylint.args`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Arguments to pass to pylint.

- **`pyls.plugins.pylint.enabled`**: `boolean`

  Enable or disable the plugin.

- **`pyls.plugins.rope_completion.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.plugins.yapf.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin.

- **`pyls.rope.extensionModules`**: `string`

  Default: `vim.NIL`
  
  Builtin and c-extension modules that are allowed to be imported and inspected by rope.

- **`pyls.rope.ropeFolder`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  The name of the folder in which rope stores project configurations and data.  Pass `null` for not using such a folder at all.

</details>

```lua
nvim_lsp.pyls.setup({config})
nvim_lsp#setup("pyls", {config})

  Default Values:
    cmd = { "pyls" }
    filetypes = { "python" }
    log_level = 2
    root_dir = vim's starting directory
    settings = {}
```

## rls

https://github.com/rust-lang/rls

rls, a language server for Rust

Refer to the following for how to setup rls itself.
https://github.com/rust-lang/rls#setup

See below for rls specific settings.
https://github.com/rust-lang/rls#configuration

If you want to use rls for a particular build, eg nightly, set cmd as follows:

```lua
cmd = {"rustup", "run", "nightly", "rls"}
```
    

```lua
nvim_lsp.rls.setup({config})
nvim_lsp#setup("rls", {config})

  Default Values:
    cmd = { "rls" }
    filetypes = { "rust" }
    log_level = 2
    root_dir = root_pattern("Cargo.toml")
    settings = {}
```

## solargraph

https://solargraph.org/

solargraph, a language server for Ruby

You can install solargraph via gem install.

```sh
gem install solargraph
```
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`solargraph.autoformat`**: `enum { true, false }`

  Enable automatic formatting while typing (WARNING: experimental)

- **`solargraph.bundlerPath`**: `string`

  Default: `"bundle"`
  
  Path to the bundle executable, defaults to 'bundle'

- **`solargraph.checkGemVersion`**: `enum { true, false }`

  Default: `true`
  
  Automatically check if a new version of the Solargraph gem is available.

- **`solargraph.commandPath`**: `string`

  Default: `"solargraph"`
  
  Path to the solargraph command.  Set this to an absolute path to select from multiple installed Ruby versions.

- **`solargraph.completion`**: `enum { true, false }`

  Default: `true`
  
  Enable completion

- **`solargraph.definitions`**: `enum { true, false }`

  Default: `true`
  
  Enable definitions (go to, etc.)

- **`solargraph.diagnostics`**: `enum { true, false }`

  Enable diagnostics

- **`solargraph.externalServer`**: `object`

  Default: `{host = "localhost",port = 7658}`
  
  The host and port to use for external transports. (Ignored for stdio and socket transports.)

- **`solargraph.folding`**: `boolean`

  Default: `true`
  
  Enable folding ranges

- **`solargraph.formatting`**: `enum { true, false }`

  Enable document formatting

- **`solargraph.hover`**: `enum { true, false }`

  Default: `true`
  
  Enable hover

- **`solargraph.logLevel`**: `enum { "warn", "info", "debug" }`

  Default: `"warn"`
  
  Level of debug info to log. `warn` is least and `debug` is most.

- **`solargraph.references`**: `enum { true, false }`

  Default: `true`
  
  Enable finding references

- **`solargraph.rename`**: `enum { true, false }`

  Default: `true`
  
  Enable symbol renaming

- **`solargraph.symbols`**: `enum { true, false }`

  Default: `true`
  
  Enable symbols

- **`solargraph.transport`**: `enum { "socket", "stdio", "external" }`

  Default: `"socket"`
  
  The type of transport to use.

- **`solargraph.useBundler`**: `boolean`

  Use `bundle exec` to run solargraph. (If this is true, the solargraph.commandPath setting is ignored.)

</details>

```lua
nvim_lsp.solargraph.setup({config})
nvim_lsp#setup("solargraph", {config})

  Default Values:
    cmd = { "solargraph", "stdio" }
    filetypes = { "ruby" }
    log_level = 2
    root_dir = root_pattern("Gemfile", ".git")
    settings = {}
```

## sumneko_lua

https://github.com/sumneko/lua-language-server

Lua language server. **By default, this doesn't have a `cmd` set.** This is
because it doesn't provide a global binary. We provide an installer for Linux
using `:LspInstall`.  If you wish to install it yourself, [here is a
guide](https://github.com/sumneko/lua-language-server/wiki/Build-and-Run).

Can be installed in neovim with `:LspInstall sumneko_lua`

```lua
nvim_lsp.sumneko_lua.setup({config})
nvim_lsp#setup("sumneko_lua", {config})

  Default Values:
    filetypes = { "lua" }
    log_level = 2
    root_dir = root_pattern(".git") or os_homedir
    settings = {}
```

## texlab

https://texlab.netlify.com/

A completion engine built from scratch for (La)TeX.

See https://texlab.netlify.com/docs/reference/configuration for configuration options.


```lua
nvim_lsp.texlab.setup({config})
nvim_lsp#setup("texlab", {config})

  Commands:
  - TexlabBuild: Build the current buffer
  
  Default Values:
    cmd = { "texlab" }
    filetypes = { "tex", "bib" }
    log_level = 2
    root_dir = vim's starting directory
    settings = {
      bibtex = {
        formatting = {
          lineLength = 120
        }
      },
      latex = {
        build = {
          args = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
          executable = "latexmk",
          onSave = false
        },
        forwardSearch = {
          args = {},
          onSave = false
        },
        lint = {
          onChange = false
        }
      }
    }
```

## tsserver

https://github.com/theia-ide/typescript-language-server

`typescript-language-server` can be installed via `:LspInstall tsserver` or by yourself with `npm`: 
```sh
npm install -g typescript-language-server
```

Can be installed in neovim with `:LspInstall tsserver`

```lua
nvim_lsp.tsserver.setup({config})
nvim_lsp#setup("tsserver", {config})

  Default Values:
    capabilities = default capabilities, with offsetEncoding utf-8
    cmd = { "typescript-language-server", "--stdio" }
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
    log_level = 2
    on_init = function to handle changing offsetEncoding
    root_dir = root_pattern("package.json")
    settings = {}
```

