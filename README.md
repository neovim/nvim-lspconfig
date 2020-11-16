# nvim-lspconfig

Collection of common configurations for the [Nvim LSP client](https://neovim.io/doc/user/lsp.html).

## Best-effort, unsupported

The configurations here are strictly **best effort and unsupported**.

This repo is (1) a place for Nvim LSP users to collaboratively provide starting
examples for the many LSP backends out there, and (2) a reference for the
current best practice (or most popular) regarding choice of server, setup, etc.

## Requires Nvim 0.5 HEAD

While Nvim LSP undergoes development, the configs in this repo assume that you
are using the latest [Nvim HEAD/nightly build](https://github.com/neovim/neovim/releases/tag/nightly).

Update Nvim and nvim-lspconfig before reporting an issue.

## Contributions

It's up to you to send improvements so that these configs align with current
best practices for a given language.

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
   Ask questions in [Neovim Gitter](https://gitter.im/neovim/neovim).
2. Choose a language from [the coc.nvim wiki](https://github.com/neoclide/coc.nvim/wiki/Language-servers) or
  [emacs-lsp](https://github.com/emacs-lsp/lsp-mode#supported-languages).
3. Create a new file at `lua/lspconfig/SERVER_NAME.lua`.
   - Copy an [existing config](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/)
     to get started. Most configs are simple. For an extensive example see
     [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/texlab.lua).

## Install

- Requires [Nvim HEAD/nightly](https://github.com/neovim/neovim/releases/tag/nightly) (v0.5 prerelease).
- nvim-lspconfig is just a plugin. Install it like any other Vim plugin, e.g. with [vim-plug](https://github.com/junegunn/vim-plug):
  ```
  :Plug 'neovim/nvim-lspconfig'
  ```
- Call `:packadd nvim-lspconfig` in your vimrc if you installed nvim-lspconfig to `'packpath'` or if you use a package manager such as minpac.

## Usage

Each config provides a `setup()` function, to initialize the server with
reasonable defaults and some server-specific things like commands or different
diagnostics.

```lua
vim.cmd('packadd nvim-lspconfig')  -- If installed as a Vim "package".
require'lspconfig'.<config>.setup{name=…, settings = {…}, …}
```

If you want to add this to your vimrc, you will need to enclose it in a `lua` block.

```vim
lua <<EOF
vim.cmd('packadd nvim-lspconfig')  -- If installed as a Vim "package".
require'lspconfig'.<config>.setup{name=…, settings = {…}, …}
EOF
```

Find the [config](#configurations) for your language, then paste the example
given there to your `init.vim`. **All examples are given in Lua,** see `:help
:lua-heredoc` to use Lua from your init.vim.

Some configs may define additional server-specific functions, e.g. the `texlab`
config provides `lspconfig.texlab.buf_build({bufnr})`.

If you want to see the location of log file, you can run this in neovim:

```
:lua print(vim.lsp.get_log_path())
```

### Example: using the defaults

To use the defaults, just call `setup()` with an empty `config` parameter.
For the `gopls` config, that would be:

```lua
vim.cmd('packadd nvim-lspconfig')  -- If installed as a Vim "package".
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

The [documentation](#configurations) for each config lists default values and
additional optional properties.

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

To configure a custom/private server, just require `lspconfig/configs` and do
the same as we do if we were adding it to the repository itself.

1. Define the config: `configs.foo_lsp = { … }`
2. Call `setup()`: `require'lspconfig'.foo_lsp.setup{}`

```lua
local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
-- Check if it's already defined for when I reload this file.
if not lspconfig.foo_lsp then
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
end
lspconfig.foo_lsp.setup{}
```

### Example: override default config

If you want to change default configs for all servers, you can override default_config like this.

```lua
local lspconfig = require'lspconfig'
lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  { log_level = lsp.protocol.MessageType.Warning.Error }
)
```

### Installing a language server

Configs may provide an `install()` function. Then you can use
`:LspInstall {name}` to install the required language server.
For example, to install the Elm language server:

    :LspInstall elmls

Use `:LspInstallInfo` to see install info.

    :LspInstallInfo

## setup() function

The `setup()` interface:

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
    - |lspconfig.util.root_pattern(patterns...)| finds an ancestor which
    - contains one of the files in `patterns...`. This is equivalent
      to coc.nvim's "rootPatterns"
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
    `function(client)` executed with the current buffer as the one the {client}
    is being attached-to. This is different from
    |vim.lsp.start_client()|'s on_attach parameter, which passes the {bufnr} as
    the second parameter instead. Useful for doing buffer-local setup.

  {on_new_config}
    `function(new_config, new_root_dir)` will be executed after a new configuration has been
    created as a result of {root_dir} returning a unique value. You can use this
    as an opportunity to further modify the new_config or use it before it is
    sent to |vim.lsp.start_client()|.
```

# Configurations

The following LSP configs are included. Follow a link to find documentation for
that config.

- [als](#als)
- [angularls](#angularls)
- [bashls](#bashls)
- [ccls](#ccls)
- [clangd](#clangd)
- [clojure_lsp](#clojure_lsp)
- [cmake](#cmake)
- [codeqlls](#codeqlls)
- [cssls](#cssls)
- [dartls](#dartls)
- [diagnosticls](#diagnosticls)
- [dockerls](#dockerls)
- [efm](#efm)
- [elixirls](#elixirls)
- [elmls](#elmls)
- [flow](#flow)
- [fortls](#fortls)
- [gdscript](#gdscript)
- [ghcide](#ghcide)
- [gopls](#gopls)
- [hie](#hie)
- [hls](#hls)
- [html](#html)
- [intelephense](#intelephense)
- [jdtls](#jdtls)
- [jedi_language_server](#jedi_language_server)
- [jsonls](#jsonls)
- [julials](#julials)
- [kotlin_language_server](#kotlin_language_server)
- [leanls](#leanls)
- [metals](#metals)
- [nimls](#nimls)
- [ocamlls](#ocamlls)
- [ocamllsp](#ocamllsp)
- [omnisharp](#omnisharp)
- [purescriptls](#purescriptls)
- [pyls](#pyls)
- [pyls_ms](#pyls_ms)
- [r_language_server](#r_language_server)
- [rls](#rls)
- [rnix](#rnix)
- [rome](#rome)
- [rust_analyzer](#rust_analyzer)
- [scry](#scry)
- [solargraph](#solargraph)
- [sourcekit](#sourcekit)
- [sqlls](#sqlls)
- [sumneko_lua](#sumneko_lua)
- [terraformls](#terraformls)
- [texlab](#texlab)
- [tsserver](#tsserver)
- [vimls](#vimls)
- [vuels](#vuels)
- [yamlls](#yamlls)

## als

https://github.com/AdaCore/ada_language_server

Ada language server. Use `LspInstall als` to install it.

Can be configured by passing a "settings" object to `als.setup{}`:

```lua
require('lspconfig').als.setup{
    settings = {
      ada = {
        projectFile = "project.gpr";
        scenarioVariables = { ... };
      }
    }
}
```

Can be installed in Nvim with `:LspInstall als`


```lua
require'lspconfig'.als.setup{}

  Commands:
  
  Default Values:
    cmd = { "ada_language_server" }
    filetypes = { "ada" }
    root_dir = util.root_pattern("Makefile", ".git")
```

## angularls

https://github.com/angular/vscode-ng-language-service

`angular-language-server` can be installed via `:LspInstall angularls`

If you prefer to install this yourself you can through npm `npm install @angular/language-server`.
Be aware there is no global binary and must be run via `node_modules/@angular/language-server/index.js`
    
Can be installed in Nvim with `:LspInstall angularls`

```lua
require'lspconfig'.angularls.setup{}

  Commands:
  
  Default Values:
    cmd = { "/home/runner/.cache/nvim/lspconfig/angularls/node_modules/.bin/angularls", "--stdio", "--tsProbeLocations", "", "--ngProbeLocations", "" }
    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" }
    root_dir = root_pattern("angular.json", ".git")
```

## bashls

https://github.com/mads-hartmann/bash-language-server

Language server for bash, written using tree sitter in typescript.

Can be installed in Nvim with `:LspInstall bashls`

```lua
require'lspconfig'.bashls.setup{}

  Commands:
  
  Default Values:
    cmd = { "bash-language-server", "start" }
    filetypes = { "sh" }
    root_dir = vim's starting directory
```

## ccls

https://github.com/MaskRay/ccls/wiki

ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.
For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html).

This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`ccls.cache.directory`**: `string`

  Default: `".ccls-cache"`
  
  Absolute or relative \(from the project root\) path to the directory that the cached index will be stored in\. Try to have this directory on an SSD\. If empty\, cached indexes will not be saved on disk\.
  
  \$\{workspaceFolder\} will be replaced by the folder where \.vscode\/settings\.json resides\.
  
  Cache directories are project\-wide\, so this should be configured in the workspace settings so multiple indexes do not clash\.
  
  Example value\: \"\/work\/ccls\-cache\/chrome\/\"

- **`ccls.cache.hierarchicalPath`**: `boolean`

  If false\, store cache files as \$directory\/\@a\@b\/c\.cc\.blob
  
  If true\, \$directory\/a\/b\/c\.cc\.blob\.

- **`ccls.callHierarchy.qualified`**: `boolean`

  Default: `true`
  
  If true\, use qualified names in the call hiearchy

- **`ccls.clang.excludeArgs`**: `array`

  Default: `{}`
  
  An set of command line arguments to strip before passing to clang when indexing\. Each list entry is a separate argument\.

- **`ccls.clang.extraArgs`**: `array`

  Default: `{}`
  
  An extra set of command line arguments to give clang when indexing\. Each list entry is a separate argument\.

- **`ccls.clang.pathMappings`**: `array`

  Default: `{}`
  
  Translate paths in compile\_commands\.json entries\, \.ccls options and cache files\. This allows to reuse cache files built otherwhere if the source paths are different\.

- **`ccls.clang.resourceDir`**: `string`

  Default: `""`
  
  Default value to use for clang \-resource\-dir argument\. This will be automatically supplied by ccls if not provided\.

- **`ccls.codeLens.enabled`**: `boolean`

  Default: `true`
  
  Specifies whether the references CodeLens should be shown\.

- **`ccls.codeLens.localVariables`**: `boolean`

  Set to false to hide code lens on parameters and function local variables\.

- **`ccls.codeLens.renderInline`**: `boolean`

  Enables a custom code lens renderer so code lens are displayed inline with code\. This removes any vertical\-space footprint at the cost of horizontal space\.

- **`ccls.completion.caseSensitivity`**: `integer`

  Default: `2`
  
  Case sensitivity when code completion is filtered\. 0\: case\-insensitive\, 1\: case\-folded\, i\.e\. insensitive if no input character is uppercase\, 2\: case\-sensitive

- **`ccls.completion.detailedLabel`**: `boolean`

  When this option is enabled\, the completion item label is very detailed\, it shows the full signature of the candidate\.

- **`ccls.completion.duplicateOptional`**: `boolean`

  For functions with default arguments\, generate one more item per default argument\.

- **`ccls.completion.enableSnippetInsertion`**: `boolean`

  If true\, parameter declarations are inserted as snippets in function\/method call arguments when completing a function\/method call

- **`ccls.completion.include.blacklist`**: `array`

  Default: `{}`
  
  ECMAScript regex that checks absolute path\. If it partially matches\, the file is not added to include path auto\-complete\. An example is \"\/CACHE\/\"

- **`ccls.completion.include.maxPathSize`**: `integer`

  Default: `37`
  
  Maximum length for path in \#include proposals\. If the path length goes beyond this number it will be elided\. Set to 0 to always display the full path\.

- **`ccls.completion.include.suffixWhitelist`**: `array`

  Default: `{ ".h", ".hpp", ".hh" }`
  
  Only files ending in one of these values will be shown in include auto\-complete\. Set to the empty\-list to disable include auto\-complete\.

- **`ccls.completion.include.whitelist`**: `array`

  Default: `{}`
  
  ECMAScript regex that checks absolute file path\. If it does not partially match\, the file is not added to include path auto\-complete\. An example is \"\/src\/\"

- **`ccls.diagnostics.blacklist`**: `array`

  Default: `{}`
  
  Files that match these patterns won\'t be displayed in diagnostics view\.

- **`ccls.diagnostics.onChange`**: `integer`

  Default: `1000`
  
  Time in milliseconds to wait before computing diagnostics on type\. \-1\: disable diagnostics on type\.

- **`ccls.diagnostics.onOpen`**: `integer`

  Default: `0`
  
  Time in milliseconds to wait before computing diagnostics when a file is opened\.

- **`ccls.diagnostics.onSave`**: `integer`

  Default: `0`
  
  Time in milliseconds to wait before computing diagnostics when a file is saved\.

- **`ccls.diagnostics.spellChecking`**: `boolean`

  Default: `true`
  
  Whether to do spell checking on undefined symbol names when computing diagnostics\.

- **`ccls.diagnostics.whitelist`**: `array`

  Default: `{}`
  
  Files that match these patterns will be displayed in diagnostics view\.

- **`ccls.highlight.blacklist`**: `array|null`

  Default: `vim.NIL`
  
  Files that match these patterns won\'t have semantic highlight\.

- **`ccls.highlight.enum.face`**: `array`

  Default: `{ "variable", "member" }`
  
  null

- **`ccls.highlight.function.colors`**: `array`

  Default: `{ "#e5b124", "#927754", "#eb992c", "#e2bf8f", "#d67c17", "#88651e", "#e4b953", "#a36526", "#b28927", "#d69855" }`
  
  Colors to use for semantic highlight\. A good generator is http\:\/\/tools\.medialab\.sciences\-po\.fr\/iwanthue\/\. If multiple colors are specified\, semantic highlight will cycle through them for successive symbols\.

- **`ccls.highlight.function.face`**: `array`

  Default: `{}`
  
  null

- **`ccls.highlight.global.face`**: `array`

  Default: `{ "fontWeight: bolder" }`
  
  null

- **`ccls.highlight.globalVariable.face`**: `array`

  Default: `{ "variable", "global" }`
  
  null

- **`ccls.highlight.largeFileSize`**: `integer|null`

  Default: `vim.NIL`
  
  Disable semantic highlight for files larger than the size\.

- **`ccls.highlight.macro.colors`**: `array`

  Default: `{ "#e79528", "#c5373d", "#e8a272", "#d84f2b", "#a67245", "#e27a33", "#9b4a31", "#b66a1e", "#e27a71", "#cf6d49" }`
  
  Colors to use for semantic highlight\. A good generator is http\:\/\/tools\.medialab\.sciences\-po\.fr\/iwanthue\/\. If multiple colors are specified\, semantic highlight will cycle through them for successive symbols\.

- **`ccls.highlight.macro.face`**: `array`

  Default: `{ "variable" }`
  
  null

- **`ccls.highlight.member.face`**: `array`

  Default: `{ "fontStyle: italic" }`
  
  null

- **`ccls.highlight.memberFunction.face`**: `array`

  Default: `{ "function", "member" }`
  
  null

- **`ccls.highlight.memberVariable.face`**: `array`

  Default: `{ "variable", "member" }`
  
  null

- **`ccls.highlight.namespace.colors`**: `array`

  Default: `{ "#429921", "#58c1a4", "#5ec648", "#36815b", "#83c65d", "#417b2f", "#43cc71", "#7eb769", "#58bf89", "#3e9f4a" }`
  
  Colors to use for semantic highlight\. A good generator is http\:\/\/tools\.medialab\.sciences\-po\.fr\/iwanthue\/\. If multiple colors are specified\, semantic highlight will cycle through them for successive symbols\.

- **`ccls.highlight.namespace.face`**: `array`

  Default: `{ "type" }`
  
  null

- **`ccls.highlight.parameter.face`**: `array`

  Default: `{ "variable" }`
  
  null

- **`ccls.highlight.static.face`**: `array`

  Default: `{ "fontWeight: bold" }`
  
  null

- **`ccls.highlight.staticMemberFunction.face`**: `array`

  Default: `{ "function", "static" }`
  
  null

- **`ccls.highlight.staticMemberVariable.face`**: `array`

  Default: `{ "variable", "static" }`
  
  null

- **`ccls.highlight.staticVariable.face`**: `array`

  Default: `{ "variable", "static" }`
  
  null

- **`ccls.highlight.type.colors`**: `array`

  Default: `{ "#e1afc3", "#d533bb", "#9b677f", "#e350b6", "#a04360", "#dd82bc", "#de3864", "#ad3f87", "#dd7a90", "#e0438a" }`
  
  Colors to use for semantic highlight\. A good generator is http\:\/\/tools\.medialab\.sciences\-po\.fr\/iwanthue\/\. If multiple colors are specified\, semantic highlight will cycle through them for successive symbols\.

- **`ccls.highlight.type.face`**: `array`

  Default: `{}`
  
  null

- **`ccls.highlight.typeAlias.face`**: `array`

  Default: `{ "type" }`
  
  null

- **`ccls.highlight.variable.colors`**: `array`

  Default: `{ "#587d87", "#26cdca", "#397797", "#57c2cc", "#306b72", "#6cbcdf", "#368896", "#3ea0d2", "#48a5af", "#7ca6b7" }`
  
  Colors to use for semantic highlight\. A good generator is http\:\/\/tools\.medialab\.sciences\-po\.fr\/iwanthue\/\. If multiple colors are specified\, semantic highlight will cycle through them for successive symbols\.

- **`ccls.highlight.variable.face`**: `array`

  Default: `{}`
  
  null

- **`ccls.highlight.whitelist`**: `array|null`

  Default: `vim.NIL`
  
  Files that match these patterns will have semantic highlight\.

- **`ccls.index.blacklist`**: `array`

  Default: `{}`
  
  A translation unit \(cc\/cpp file\) is not indexed if any of the ECMAScript regexes in this list partially matches translation unit\'s the absolute path\.

- **`ccls.index.initialBlacklist`**: `array`

  Default: `{}`
  
  Files matched by the regexes should not be indexed on initialization\. Indexing is deferred to when they are opened\.

- **`ccls.index.initialWhitelist`**: `array`

  Default: `{}`
  
  Files matched by the regexes should be indexed on initialization\.

- **`ccls.index.maxInitializerLines`**: `integer`

  Default: `15`
  
  Number of lines of the initializer \/ macro definition showed in hover\.

- **`ccls.index.multiVersion`**: `integer`

  Default: `0`
  
  If not 0\, a file will be indexed in each tranlation unit that includes it\.

- **`ccls.index.onChange`**: `boolean`

  Allow indexing on textDocument\/didChange\. May be too slow for big projects\, so it is off by default\.

- **`ccls.index.threads`**: `number`

  Default: `0`
  
  Number of indexer threads\. If 0\, 80\% of cores are used\.

- **`ccls.index.trackDependency`**: `integer`

  Default: `2`
  
  Whether to reparse a file if write times of its dependencies have changed\. The file will always be reparsed if its own write time changes\.
  
  0\: no\, 1\: only during initial load of project\, 2\: yes

- **`ccls.index.whitelist`**: `array`

  Default: `{}`
  
  If a translation unit\'s absolute path partially matches any ECMAScript regex in this list\, it will be indexed\. The whitelist takes priority over the blacklist\. To only index files in the whitelist\, make \"ccls\.index\.blacklist\" match everything\, ie\, set it to \"\.\*\"\.

- **`ccls.launch.args`**: `array`

  Default: `{}`
  
  Array containing extra arguments to pass to the ccls binary

- **`ccls.launch.command`**: `string`

  Default: `"ccls"`
  
  Path to the ccls binary \(default assumes the binary is in the PATH\)

- **`ccls.misc.compilationDatabaseCommand`**: `string`

  Default: `""`
  
  If not empty\, the compilation database command to use

- **`ccls.misc.compilationDatabaseDirectory`**: `string`

  Default: `""`
  
  If not empty\, the compilation database directory to use instead of the project root

- **`ccls.misc.showInactiveRegions`**: `boolean`

  Default: `true`
  
  If true\, ccls will highlight skipped ranges\.

- **`ccls.statusUpdateInterval`**: `integer`

  Default: `2000`
  
  Interval between updating ccls status in milliseconds\. Set to 0 to disable\.

- **`ccls.theme.dark.skippedRange.backgroundColor`**: `string`

  Default: `"rgba(18, 18, 18, 0.3)"`
  
  CSS color to apply to the background when the code region has been disabled by the preprocessor in a dark theme\.

- **`ccls.theme.dark.skippedRange.textColor`**: `string`

  Default: `"rgb(100, 100, 100)"`
  
  CSS color to apply to text when the code region has been disabled by the preprocessor in a dark theme\.

- **`ccls.theme.light.skippedRange.backgroundColor`**: `string`

  Default: `"rgba(220, 220, 220, 0.3)"`
  
  CSS color to apply to the background when the code region has been disabled by the preprocessor in a light theme\.

- **`ccls.theme.light.skippedRange.textColor`**: `string`

  Default: `"rgb(100, 100, 100)"`
  
  CSS color to apply to text when the code region has been disabled by the preprocessor in a light theme\.

- **`ccls.trace.websocketEndpointUrl`**: `string`

  Default: `""`
  
  When set\, logs all LSP messages to specified WebSocket endpoint\.

- **`ccls.treeViews.doubleClickTimeoutMs`**: `number`

  Default: `500`
  
  If a tree view entry is double\-clicked within this timeout value\, vscode will navigate to the entry\.

- **`ccls.workspaceSymbol.caseSensitivity`**: `integer`

  Default: `1`
  
  Case sensitivity when searching workspace symbols\. 0\: case\-insensitive\, 1\: case\-folded\, i\.e\. insensitive if no input character is uppercase\, 2\: case\-sensitive

- **`ccls.workspaceSymbol.maxNum`**: `number|null`

  Default: `vim.NIL`
  
  The maximum number of global search \(ie\, Ctrl+P + \#foo\) search results to report\. For small search strings on large projects there can be a massive number of results \(ie\, over 1\,000\,000\) so this limit is important to avoid extremely long delays\. null means use the default value provided by the ccls language server\.

</details>

```lua
require'lspconfig'.ccls.setup{}

  Commands:
  
  Default Values:
    cmd = { "ccls" }
    filetypes = { "c", "cpp", "objc", "objcpp" }
    root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git")
```

## clangd

https://clang.llvm.org/extra/clangd/Installation.html

**NOTE:** Clang >= 9 is recommended! See [this issue for more](https://github.com/neovim/nvim-lsp/issues/23).

clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.
For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html).


```lua
require'lspconfig'.clangd.setup{}

  Commands:
  - ClangdSwitchSourceHeader: Switch between source/header
  
  Default Values:
    capabilities = default capabilities, with offsetEncoding utf-8
    cmd = { "clangd", "--background-index" }
    filetypes = { "c", "cpp", "objc", "objcpp" }
    on_init = function to handle changing offsetEncoding
    root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git") or dirname
```

## clojure_lsp

https://github.com/snoe/clojure-lsp

Clojure Language Server


```lua
require'lspconfig'.clojure_lsp.setup{}

  Commands:
  
  Default Values:
    cmd = { "clojure-lsp" }
    filetypes = { "clojure", "edn" }
    root_dir = root_pattern("project.clj", "deps.edn", ".git")
```

## cmake

https://github.com/regen100/cmake-language-server

CMake LSP Implementation


```lua
require'lspconfig'.cmake.setup{}

  Commands:
  
  Default Values:
    cmd = { "cmake-language-server" }
    filetypes = { "cmake" }
    init_options = {
      buildDirectory = "build"
    }
    root_dir = root_pattern(".git", "compile_commands.json", "build")
```

## codeqlls

Reference:
https://help.semmle.com/codeql/codeql-cli.html

Binaries:
https://github.com/github/codeql-cli-binaries
        
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`codeQL.cli.executablePath`**: `string`

  Default: `""`
  
  Path to the CodeQL executable that should be used by the CodeQL extension\. The executable is named \`codeql\` on Linux\/Mac and \`codeql\.exe\` on Windows\. This overrides all other CodeQL CLI settings\.

- **`codeQL.queryHistory.format`**: `string`

  Default: `"[%t] %q on %d - %s"`
  
  Default string for how to label query history items\. \%t is the time of the query\, \%q is the query name\, \%d is the database name\, and \%s is a status string\.

- **`codeQL.runningQueries.autoSave`**: `boolean`

  Enable automatically saving a modified query file when running a query\.

- **`codeQL.runningQueries.debug`**: `boolean`

  Enable debug logging and tuple counting when running CodeQL queries\. This information is useful for debugging query performance\.

- **`codeQL.runningQueries.maxQueries`**: `integer`

  Default: `20`
  
  Max number of simultaneous queries to run using the \'CodeQL\: Run Queries\' command\.

- **`codeQL.runningQueries.memory`**: `integer|null`

  Default: `vim.NIL`
  
  Memory \(in MB\) to use for running queries\. Leave blank for CodeQL to choose a suitable value based on your system\'s available memory\.

- **`codeQL.runningQueries.numberOfThreads`**: `integer`

  Default: `1`
  
  Number of threads for running queries\.

- **`codeQL.runningQueries.timeout`**: `integer|null`

  Default: `vim.NIL`
  
  Timeout \(in seconds\) for running queries\. Leave blank or set to zero for no timeout\.

- **`codeQL.runningTests.numberOfThreads`**: `integer`

  Default: `1`
  
  Number of threads for running CodeQL tests\.

</details>

```lua
require'lspconfig'.codeqlls.setup{}

  Commands:
  
  Default Values:
    before_init = <function 1>
    cmd = { "codeql", "execute", "language-server", "--check-errors", "ON_CHANGE", "-q" }
    filetypes = { "ql" }
    log_level = 2
    root_dir = <function 1>
    settings = {
      search_path = "list containing all search paths, eg: '~/codeql-home/codeql-repo'"
    }
```

## cssls

https://github.com/vscode-langservers/vscode-css-languageserver-bin

`css-languageserver` can be installed via `:LspInstall cssls` or by yourself with `npm`:
```sh
npm install -g vscode-css-languageserver-bin
```

Can be installed in Nvim with `:LspInstall cssls`

```lua
require'lspconfig'.cssls.setup{}

  Commands:
  
  Default Values:
    cmd = { "css-languageserver", "--stdio" }
    filetypes = { "css", "scss", "less" }
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

## dartls

https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec

Language server for dart.

This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`dart.additionalAnalyzerFileExtensions`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Additional file extensions that should be analyzed \(usually used in combination with analyzer plugins\)\.

- **`dart.allowAnalytics`**: `boolean`

  Default: `true`
  
  Whether to send analytics such as startup timings\, frequency of use of features and analysis server crashes\.

- **`dart.allowTestsOutsideTestFolder`**: `boolean`

  null

- **`dart.analysisExcludedFolders`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  An array of paths to be excluded from Dart analysis\. This option should usually be set at the Workspace level\.

- **`dart.analysisServerFolding`**: `boolean`

  Default: `true`
  
  Whether to use folding data from the Dart analysis server instead of the built\-in VS Code indent\-based folding\.

- **`dart.analyzeAngularTemplates`**: `boolean`

  Default: `true`
  
  null

- **`dart.analyzerAdditionalArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Additional arguments to pass to the Dart analysis server\.

- **`dart.analyzerDiagnosticsPort`**: `null|number`

  Default: `vim.NIL`
  
  The port number to be used for the Dart analyzer diagnostic server\.

- **`dart.analyzerInstrumentationLogFile`**: `null|string`

  Default: `vim.NIL`
  
  The path to a log file for very detailed logging in the Dart analysis server that may be useful when trying to diagnose analysis server issues\.

- **`dart.analyzerLogFile`**: `null|string`

  Default: `vim.NIL`
  
  The path to a log file for communication between Dart Code and the analysis server\.

- **`dart.analyzerPath`**: `null|string`

  Default: `vim.NIL`
  
  The path to a custom Dart analysis server\.

- **`dart.analyzerSshHost`**: `null|string`

  Default: `vim.NIL`
  
  An SSH host to run the analysis server\.
  This can be useful when modifying code on a remote machine using SSHFS\.

- **`dart.analyzerVmServicePort`**: `null|number`

  Default: `vim.NIL`
  
  The port number to be used for the Dart analysis server VM service\.

- **`dart.autoImportCompletions`**: `boolean`

  Default: `true`
  
  Whether to include symbols that have not been imported in the code completion list and automatically insert the required import when selecting them\.

- **`dart.buildRunnerAdditionalArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  null

- **`dart.checkForSdkUpdates`**: `boolean`

  Default: `true`
  
  Whether to check you are using the latest version of the Dart SDK at startup\.

- **`dart.closingLabels`**: `boolean`

  Default: `true`
  
  Whether to show annotations against constructor\, method invocations and lists that span multiple lines\.

- **`dart.completeFunctionCalls`**: `boolean`

  Default: `true`
  
  null

- **`dart.debugExtensionBackendProtocol`**: `enum { "sse", "ws" }`

  Default: `"ws"`
  
  The protocol to use for the Dart Debug Extension backend service\. Using WebSockets can improve performance but may fail when connecting through some proxy servers\.

- **`dart.debugExternalLibraries`**: `boolean`

  null

- **`dart.debugSdkLibraries`**: `boolean`

  null

- **`dart.devToolsBrowser`**: `enum { "chrome", "default" }`

  Default: `"chrome"`
  
  Whether to launch external DevTools windows using Chrome or the system default browser\.

- **`dart.devToolsLogFile`**: `null|string`

  Default: `vim.NIL`
  
  The path to a low\-traffic log file for the Dart DevTools service\.

- **`dart.devToolsPort`**: `null|number`

  Default: `vim.NIL`
  
  The port number to be used for the Dart DevTools\.

- **`dart.devToolsReuseWindows`**: `boolean`

  Default: `true`
  
  Whether to try to reuse existing DevTools windows instead of launching new ones\. Only works for instances of DevTools launched by the DevTools server on the local machine\.

- **`dart.devToolsTheme`**: `enum { "dark", "light" }`

  Default: `"dark"`
  
  The theme to use for Dart DevTools\.

- **`dart.doNotFormat`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  null

- **`dart.embedDevTools`**: `boolean`

  Default: `true`
  
  null

- **`dart.enableCompletionCommitCharacters`**: `boolean`

  null

- **`dart.enableSdkFormatter`**: `boolean`

  Default: `true`
  
  null

- **`dart.enableSnippets`**: `boolean`

  Default: `true`
  
  Whether to include Dart and Flutter snippets in code completion\.

- **`dart.env`**: `object`

  Default: `vim.empty_dict()`
  
  Additional environment variables to be added to all Dart\/Flutter processes spawned by the Dart and Flutter extensions\.

- **`dart.evaluateGettersInDebugViews`**: `boolean`

  Default: `true`
  
  Whether to evaluate getters in order to display them in debug views \(such as the Variables\, Watch and Hovers views\)\.

- **`dart.evaluateToStringInDebugViews`**: `boolean`

  Default: `true`
  
  Whether to call toString\(\) on objects when rendering them in debug views \(such as the Variables\, Watch and Hovers views\)\. Only applies to views of 100 or fewer values for performance reasons\.

- **`dart.extensionLogFile`**: `null|string`

  Default: `vim.NIL`
  
  The path to a low\-traffic log file for basic extension and editor issues\.

- **`dart.flutterAdbConnectOnChromeOs`**: `boolean`

  null

- **`dart.flutterAdditionalArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  null

- **`dart.flutterCreateAndroidLanguage`**: `enum { "java", "kotlin" }`

  Default: `"kotlin"`
  
  The programming language to use for Android apps when creating new projects using the \'Flutter\: New Project\' command\.

- **`dart.flutterCreateIOSLanguage`**: `enum { "objc", "swift" }`

  Default: `"swift"`
  
  The programming language to use for iOS apps when creating new projects using the \'Flutter\: New Project\' command\.

- **`dart.flutterCreateOffline`**: `boolean`

  Whether to use offline mode when creating new projects with the \'Flutter\: New Project\' command\.

- **`dart.flutterCreateOrganization`**: `null|string`

  Default: `vim.NIL`
  
  null

- **`dart.flutterCustomEmulators`**: `array`

  Default: `{}`
  
  Array items: `{properties = {args = {items = {type = "string"},type = "array"},executable = {type = "string"},id = {type = "string"},name = {type = "string"}},type = "object"}`
  
  Custom emulators to show in the emulator list for easier launching\. If IDs match existing emulators returned by Flutter\, the custom emulators will override them\.

- **`dart.flutterDaemonLogFile`**: `null|string`

  Default: `vim.NIL`
  
  null

- **`dart.flutterGutterIcons`**: `boolean`

  Default: `true`
  
  Whether to show Flutter icons and colors in the editor gutter\.

- **`dart.flutterHotReloadOnSave`**: `boolean`

  Default: `true`
  
  Whether to automatically send a Hot Reload request during a debug session when saving files\.

- **`dart.flutterHotRestartOnSave`**: `boolean`

  Default: `true`
  
  Whether to automatically send a Hot Restart request during a debug session when saving files if Hot Reload is not available but Hot Restart is\.

- **`dart.flutterOutline`**: `boolean`

  Default: `true`
  
  Whether to show the Flutter Outline tree in the sidebar\.

- **`dart.flutterRunLogFile`**: `null|string`

  Default: `vim.NIL`
  
  null

- **`dart.flutterScreenshotPath`**: `null|string`

  Default: `vim.NIL`
  
  The path to a directory to save Flutter screenshots\.

- **`dart.flutterSdkPath`**: `null|string`

  Default: `vim.NIL`
  
  null

- **`dart.flutterSdkPaths`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  An array of paths that either directly point to a Flutter SDK or the parent directory of multiple Flutter SDKs\. When set\, the version number in the status bar can be used to quickly switch between SDKs\.

- **`dart.flutterSelectDeviceWhenConnected`**: `boolean`

  Default: `true`
  
  Whether to set newly connected devices as the current device in Flutter projects\.

- **`dart.flutterStructuredErrors`**: `boolean`

  Default: `true`
  
  null

- **`dart.flutterTestAdditionalArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  null

- **`dart.flutterTestLogFile`**: `null|string`

  Default: `vim.NIL`
  
  null

- **`dart.flutterTrackWidgetCreation`**: `boolean`

  Default: `true`
  
  null

- **`dart.insertArgumentPlaceholders`**: `boolean`

  Default: `true`
  
  null

- **`dart.lineLength`**: `integer`

  Default: `80`
  
  The maximum length of a line of code\. This is used by the document formatter\.

- **`dart.maxLogLineLength`**: `number`

  Default: `2000`
  
  The maximum length of a line in the log file\. Lines longer than this will be truncated and suffixed with an ellipsis\.

- **`dart.notifyAnalyzerErrors`**: `boolean`

  Default: `true`
  
  Whether to show a notification the first few times an analysis server exception occurs\.

- **`dart.openDevTools`**: `enum { "never", "flutter", "always" }`

  Default: `"never"`
  
  Whether to automatically open DevTools at the start of a debug session\.

- **`dart.openTestView`**: `array`

  Default: `{ "testRunStart" }`
  
  Array items: `{enum = { "testRunStart", "testFailure" }}`
  
  When to automatically switch focus to the test list \(array to support multiple values\)\.

- **`dart.previewBazelWorkspaceCustomScripts`**: `boolean`

  null

- **`dart.previewCommitCharacters`**: `boolean`

  EXPERIMENTAL\: Whether to enable commit characters for the LSP server\. In a future release\, the dart\.enableCompletionCommitCharacters setting will also apply to LSP\.

- **`dart.previewFlutterUiGuides`**: `boolean`

  null

- **`dart.previewFlutterUiGuidesCustomTracking`**: `boolean`

  Whether to enable custom tracking of Flutter UI guidelines \(to hide some latency of waiting for the next Flutter Outline\)\.

- **`dart.previewHotReloadOnSaveWatcher`**: `boolean`

  null

- **`dart.previewLsp`**: `boolean`

  null

- **`dart.promptToGetPackages`**: `boolean`

  Default: `true`
  
  Whether to prompt to get packages when opening a project with out of date packages\.

- **`dart.promptToRunIfErrors`**: `boolean`

  Default: `true`
  
  Whether to prompt before running if there are errors in your project\. Test scripts will be excluded from the check unless they\'re the script being run\.

- **`dart.pubAdditionalArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Additional args to pass to all pub commands\.

- **`dart.pubTestLogFile`**: `null|string`

  Default: `vim.NIL`
  
  null

- **`dart.runPubGetOnPubspecChanges`**: `boolean`

  Default: `true`
  
  null

- **`dart.sdkPath`**: `null|string`

  Default: `vim.NIL`
  
  null

- **`dart.sdkPaths`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  An array of paths that either directly point to a Dart SDK or the parent directory of multiple Dart SDKs\. When set\, the version number in the status bar can be used to quickly switch between SDKs\.

- **`dart.showDartDeveloperLogs`**: `boolean`

  Default: `true`
  
  null

- **`dart.showDartPadSampleCodeLens`**: `boolean`

  Default: `true`
  
  Whether to show CodeLens actions in the editor for opening online DartPad samples\.

- **`dart.showDevToolsDebugToolBarButtons`**: `boolean`

  Default: `true`
  
  Whether to show DevTools buttons in the Debug toolbar\.

- **`dart.showIgnoreQuickFixes`**: `boolean`

  Default: `true`
  
  Whether to show quick fixes for ignoring hints and lints\.

- **`dart.showMainCodeLens`**: `boolean`

  Default: `true`
  
  Whether to show CodeLens actions in the editor for quick running \/ debugging scripts with main functions\.

- **`dart.showTestCodeLens`**: `boolean`

  Default: `true`
  
  Whether to show CodeLens actions in the editor for quick running \/ debugging tests\.

- **`dart.showTodos`**: `boolean`

  Default: `true`
  
  Whether to show TODOs in the Problems list\.

- **`dart.triggerSignatureHelpAutomatically`**: `boolean`

  Whether to automatically trigger signature help when pressing keys such as \, and \(\.

- **`dart.updateImportsOnRename`**: `boolean`

  Default: `true`
  
  Whether to automatically update imports when moving or renaming files\. Currently only supports single file moves \/ renames\.

- **`dart.useKnownChromeOSPorts`**: `boolean`

  Default: `true`
  
  Whether to use specific ports for the VM service and DevTools when running in Chrome OS\. This is required to connect from the native Chrome OS browser but will prevent apps from launching if the ports are already in\-use \(for example if trying to run a second app\)\.

- **`dart.vmAdditionalArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Additional args to pass to the Dart VM when running\/debugging command line apps\.

- **`dart.vmServiceLogFile`**: `null|string`

  Default: `vim.NIL`
  
  null

- **`dart.warnWhenEditingFilesInPubCache`**: `boolean`

  Default: `true`
  
  null

- **`dart.warnWhenEditingFilesOutsideWorkspace`**: `boolean`

  Default: `true`
  
  Whether to show a warning when modifying files outside of the workspace\.

- **`dart.webDaemonLogFile`**: `null|string`

  Default: `vim.NIL`
  
  null

</details>

```lua
require'lspconfig'.dartls.setup{}

  Commands:
  
  Default Values:
    cmd = { "dart", "./snapshots/analysis_server.dart.snapshot", "--lsp" }
    filetypes = { "dart" }
    init_options = {
      closingLabels = "true",
      flutterOutline = "false",
      onlyAnalyzeProjectsWithOpenFiles = "false",
      outline = "true",
      suggestFromUnimportedLibraries = "true"
    }
    root_dir = root_pattern("pubspec.yaml")
```

## diagnosticls

https://github.com/iamcco/diagnostic-languageserver

Diagnostic language server integrate with linters.

Can be installed in Nvim with `:LspInstall diagnosticls`

```lua
require'lspconfig'.diagnosticls.setup{}

  Commands:
  
  Default Values:
    cmd = { "diagnostic-languageserver", "--stdio" }
    filetypes = Empty by default, override to add filetypes
    root_dir = Vim's starting directory
```

## dockerls

https://github.com/rcjsuen/dockerfile-language-server-nodejs

`docker-langserver` can be installed via `:LspInstall dockerls` or by yourself with `npm`:
```sh
npm install -g dockerfile-language-server-nodejs
```
    
Can be installed in Nvim with `:LspInstall dockerls`

```lua
require'lspconfig'.dockerls.setup{}

  Commands:
  
  Default Values:
    cmd = { "docker-langserver", "--stdio" }
    filetypes = { "Dockerfile", "dockerfile" }
    root_dir = root_pattern("Dockerfile")
```

## efm

https://github.com/mattn/efm-langserver

General purpose Language Server that can use specified error message format generated from specified command.


```lua
require'lspconfig'.efm.setup{}

  Commands:
  
  Default Values:
    cmd = { "efm-langserver" }
    root_dir = root_pattern(".git")
```

## elixirls

https://github.com/elixir-lsp/elixir-ls

`elixir-ls` can be installed via `:LspInstall elixirls` or by yourself by following the instructions [here](https://github.com/elixir-lsp/elixir-ls#building-and-running).

This language server does not provide a global binary, but must be installed manually. The command `:LspInstaller elixirls` makes an attempt at installing the binary by
Fetching the elixir-ls repository from GitHub, compiling it and then installing it.

```lua
require'lspconfig'.elixirls.setup{
    -- Unix
    cmd = { "path/to/language_server.sh" };
    -- Windows
    cmd = { "path/to/language_server.bat" };
    ...
}
```

Can be installed in Nvim with `:LspInstall elixirls`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`elixirLS.dialyzerEnabled`**: `boolean`

  Default: `true`
  
  Run ElixirLS\'s rapid Dialyzer when code is saved

- **`elixirLS.dialyzerFormat`**: `enum { "dialyzer", "dialyxir_short", "dialyxir_long" }`

  Default: `"dialyzer"`
  
  Formatter to use for Dialyzer warnings

- **`elixirLS.dialyzerWarnOpts`**: `array`

  Default: `{}`
  
  Array items: `{enum = { "error_handling", "no_behaviours", "no_contracts", "no_fail_call", "no_fun_app", "no_improper_lists", "no_match", "no_missing_calls", "no_opaque", "no_return", "no_undefined_callbacks", "no_unused", "underspecs", "unknown", "unmatched_returns", "overspecs", "specdiffs" },type = "string"}`
  
  Dialyzer options to enable or disable warnings\. See Dialyzer\'s documentation for options\. Note that the \"race\_conditions\" option is unsupported

- **`elixirLS.fetchDeps`**: `boolean`

  Default: `true`
  
  Automatically fetch project dependencies when compiling

- **`elixirLS.mixEnv`**: `string`

  Default: `"test"`
  
  Mix environment to use for compilation

- **`elixirLS.projectDir`**: `string`

  Subdirectory containing Mix project if not in the project root

- **`elixirLS.suggestSpecs`**: `boolean`

  Default: `true`
  
  Suggest \@spec annotations inline using Dialyzer\'s inferred success typings \(Requires Dialyzer\)

</details>

```lua
require'lspconfig'.elixirls.setup{}

  Commands:
  
  Default Values:
    cmd = { "language_server.sh" }
    filetypes = { "elixir", "eelixir" }
    root_dir = root_pattern("mix.exs", ".git") or vim.loop.os_homedir()
```

## elmls

https://github.com/elm-tooling/elm-language-server#installation

If you don't want to use Nvim to install it, then you can use:
```sh
npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
```

Can be installed in Nvim with `:LspInstall elmls`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`elmLS.disableElmLSDiagnostics`**: `boolean`

  Disable linting diagnostics from the language server\.

- **`elmLS.elmAnalyseTrigger`**: `enum { "change", "save", "never" }`

  Default: `"never"`
  
  When do you want the extension to run elm\-analyse\? Might need a restart to take effect\.

- **`elmLS.elmFormatPath`**: `string`

  Default: `""`
  
  The path to your elm\-format executable\. Should be empty by default\, in that case it will assume the name and try to first get it from a local npm installation or a global one\. If you set it manually it will not try to load from the npm folder\.

- **`elmLS.elmPath`**: `string`

  Default: `""`
  
  The path to your elm executable\. Should be empty by default\, in that case it will assume the name and try to first get it from a local npm installation or a global one\. If you set it manually it will not try to load from the npm folder\.

- **`elmLS.elmTestPath`**: `string`

  Default: `""`
  
  The path to your elm\-test executable\. Should be empty by default\, in that case it will assume the name and try to first get it from a local npm installation or a global one\. If you set it manually it will not try to load from the npm folder\.

- **`elmLS.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Traces the communication between VS Code and the language server\.

</details>

```lua
require'lspconfig'.elmls.setup{}

  Commands:
  
  Default Values:
    cmd = { "elm-language-server" }
    filetypes = { "elm" }
    init_options = {
      elmAnalyseTrigger = "change",
      elmFormatPath = "elm-format",
      elmPath = "elm",
      elmTestPath = "elm-test"
    }
    root_dir = root_pattern("elm.json")
```

## flow

https://flow.org/
https://github.com/facebook/flow

See below for how to setup Flow itself.
https://flow.org/en/docs/install/

See below for lsp command options.

```sh
npx flow lsp --help
```
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`flow.coverageSeverity`**: `enum { "error", "warn", "info" }`

  Default: `"info"`
  
  Type coverage diagnostic severity

- **`flow.enabled`**: `boolean`

  Default: `true`
  
  Is flow enabled

- **`flow.fileExtensions`**: `array`

  Default: `{ ".js", ".mjs", ".jsx", ".flow", ".json" }`
  
  Array items: `{type = "string"}`
  
  \(Supported only when useLSP\: false\)\. File extensions to consider for flow processing

- **`flow.lazyMode`**: `string`

  Default: `vim.NIL`
  
  Set value to enable flow lazy mode

- **`flow.logLevel`**: `enum { "error", "warn", "info", "trace" }`

  Default: `"info"`
  
  Log level for output panel logs

- **`flow.pathToFlow`**: `string`

  Default: `"flow"`
  
  Absolute path to flow binary\. Special var \$\{workspaceFolder\} or \$\{flowconfigDir\} can be used in path \(NOTE\: in windows you can use \'\/\' and can omit \'\.cmd\' in path\)

- **`flow.runOnAllFiles`**: `boolean`

  \(Supported only when useLSP\: false\) Run Flow on all files\, No need to put \/\/\@flow comment on top of files\.

- **`flow.runOnEdit`**: `boolean`

  Default: `true`
  
  If true will run flow on every edit\, otherwise will run only when changes are saved \(Note\: \'useLSP\: true\' only supports syntax errors\)

- **`flow.showStatus`**: `boolean`

  Default: `true`
  
  \(Supported only when useLSP\: false\) If true will display flow status is the statusbar

- **`flow.showUncovered`**: `boolean`

  If true will show uncovered code by default

- **`flow.stopFlowOnExit`**: `boolean`

  Default: `true`
  
  Stop Flow on Exit

- **`flow.trace.server`**

  Default: `"off"`
  
  Traces the communication between VSCode and the flow lsp service\.

- **`flow.useBundledFlow`**: `boolean`

  Default: `true`
  
  If true will use flow bundled with this plugin if nothing works

- **`flow.useCodeSnippetOnFunctionSuggest`**: `boolean`

  Default: `true`
  
  Complete functions with their parameter signature\.

- **`flow.useLSP`**: `boolean`

  Default: `true`
  
  Turn off to switch from the official Flow Language Server implementation to talking directly to flow\.

- **`flow.useNPMPackagedFlow`**: `boolean`

  Default: `true`
  
  Support using flow through your node\_modules folder\, WARNING\: Checking this box is a security risk\. When you open a project we will immediately run code contained within it\.

</details>

```lua
require'lspconfig'.flow.setup{}

  Commands:
  
  Default Values:
    cmd = { "npx", "--no-install", "flow", "lsp" }
    filetypes = { "javascript", "javascriptreact", "javascript.jsx" }
    root_dir = root_pattern(".flowconfig")
```

## fortls

https://github.com/hansec/fortran-language-server

Fortran Language Server for the Language Server Protocol
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`fortran-ls.autocompletePrefix`**: `boolean`

  Filter autocomplete suggestions with variable prefix

- **`fortran-ls.disableDiagnostics`**: `boolean`

  Disable diagnostics \(requires v1\.12\.0+\)\.

- **`fortran-ls.displayVerWarning`**: `boolean`

  Default: `true`
  
  Provides notifications when the underlying language server is out of date\.

- **`fortran-ls.enableCodeActions`**: `boolean`

  Enable experimental code actions \(requires v1\.7\.0+\)\.

- **`fortran-ls.executablePath`**: `string`

  Default: `"fortls"`
  
  Path to the Fortran language server \(fortls\)\.

- **`fortran-ls.hoverSignature`**: `boolean`

  Show signature information in hover for argument \(also enables \'variableHover\'\)\.

- **`fortran-ls.includeSymbolMem`**: `boolean`

  Default: `true`
  
  Include type members in document outline \(also used for \'Go to Symbol in File\'\)

- **`fortran-ls.incrementalSync`**: `boolean`

  Default: `true`
  
  Use incremental synchronization for file changes\.

- **`fortran-ls.lowercaseIntrinsics`**: `boolean`

  Use lowercase for intrinsics and keywords in autocomplete requests\.

- **`fortran-ls.maxCommentLineLength`**: `number`

  Default: `-1`
  
  Maximum comment line length \(requires v1\.8\.0+\)\.

- **`fortran-ls.maxLineLength`**: `number`

  Default: `-1`
  
  Maximum line length \(requires v1\.8\.0+\)\.

- **`fortran-ls.notifyInit`**: `boolean`

  Notify when workspace initialization is complete \(requires v1\.7\.0+\)\.

- **`fortran-ls.useSignatureHelp`**: `boolean`

  Default: `true`
  
  Use signature help instead of snippets when available\.

- **`fortran-ls.variableHover`**: `boolean`

  Show hover information for variables\.

</details>

```lua
require'lspconfig'.fortls.setup{}

  Commands:
  
  Default Values:
    cmd = { "fortls" }
    filetypes = { "fortran" }
    root_dir = root_pattern(".fortls")
    settings = {
      nthreads = 1
    }
```

## gdscript

https://github.com/godotengine/godot

Language server for GDScript, used by Godot Engine.


```lua
require'lspconfig'.gdscript.setup{}

  Commands:
  
  Default Values:
    cmd = { "nc", "localhost", "6008" }
    filetypes = { "gd", "gdscript", "gdscript3" }
    root_dir = <function 1>
```

## ghcide

https://github.com/digital-asset/ghcide

A library for building Haskell IDE tooling.

This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`hic.arguments`**: `string`

  Default: `"--lsp"`
  
  The arguments you would like to pass to the executable

- **`hic.executablePath`**: `string`

  Default: `"ghcide"`
  
  The location of your ghcide executable

</details>

```lua
require'lspconfig'.ghcide.setup{}

  Commands:
  
  Default Values:
    cmd = { "ghcide", "--lsp" }
    filetypes = { "haskell", "lhaskell" }
    root_dir = root_pattern("stack.yaml", "hie-bios", "BUILD.bazel", "cabal.config", "package.yaml")
```

## gopls

https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.


```lua
require'lspconfig'.gopls.setup{}

  Commands:
  
  Default Values:
    cmd = { "gopls" }
    filetypes = { "go", "gomod" }
    root_dir = root_pattern("go.mod", ".git")
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
        
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`haskell.completionSnippetsOn`**: `boolean`

  Default: `true`
  
  Show snippets with type information when using code completion

- **`haskell.diagnosticsOnChange`**: `boolean`

  Default: `true`
  
  Compute diagnostics continuously as you type\. Turn off to only generate diagnostics on file save\.

- **`haskell.formatOnImportOn`**: `boolean`

  Default: `true`
  
  When adding an import\, use the formatter on the result

- **`haskell.formattingProvider`**: `enum { "brittany", "floskell", "fourmolu", "ormolu", "stylish-haskell", "none" }`

  Default: `"ormolu"`
  
  The formatter to use when formatting a document or range

- **`haskell.hlintOn`**: `boolean`

  Default: `true`
  
  Get suggestions from hlint

- **`haskell.languageServerVariant`**: `enum { "haskell-ide-engine", "haskell-language-server", "ghcide" }`

  Default: `"haskell-language-server"`
  
  Which language server to use\.

- **`haskell.liquidOn`**: `boolean`

  Get diagnostics from liquid haskell

- **`haskell.logFile`**: `string`

  Default: `""`
  
  If set\, redirects the logs to a file\.

- **`haskell.maxNumberOfProblems`**: `number`

  Default: `100`
  
  Controls the maximum number of problems produced by the server

- **`haskell.releasesURL`**: `string`

  Default: `""`
  
  An optional URL to override where to check for haskell\-language\-server releases

- **`haskell.serverExecutablePath`**: `string`

  Default: `""`
  
  Manually set a language server executable\. Can be something on the \$PATH or a path to an executable itself\. Works with ~\, \$\{HOME\} and \$\{workspaceFolder\}\.

- **`haskell.trace.server`**: `enum { "off", "messages" }`

  Default: `"off"`
  
  Traces the communication between VS Code and the language server\.

- **`haskell.updateBehavior`**: `enum { "keep-up-to-date", "prompt", "never-check" }`

  Default: `"keep-up-to-date"`
  
  null

</details>

```lua
require'lspconfig'.hie.setup{}

  Commands:
  
  Default Values:
    cmd = { "hie-wrapper", "--lsp" }
    filetypes = { "haskell" }
    root_dir = root_pattern("stack.yaml", "package.yaml", ".git")
```

## hls

https://github.com/haskell/haskell-language-server

Haskell Language Server
        

```lua
require'lspconfig'.hls.setup{}

  Commands:
  
  Default Values:
    cmd = { "haskell-language-server-wrapper", "--lsp" }
    filetypes = { "haskell", "lhaskell" }
    root_dir = root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml")
```

## html

https://github.com/vscode-langservers/vscode-html-languageserver-bin

`html-languageserver` can be installed via `:LspInstall html` or by yourself with `npm`:
```sh
npm install -g vscode-html-languageserver-bin
```

Can be installed in Nvim with `:LspInstall html`

```lua
require'lspconfig'.html.setup{}

  Commands:
  
  Default Values:
    cmd = { "html-languageserver", "--stdio" }
    filetypes = { "html" }
    init_options = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true
      }
    }
    root_dir = <function 1>
    settings = {}
```

## intelephense

https://intelephense.com/

`intelephense` can be installed via `:LspInstall intelephense` or by yourself with `npm`:
```sh
npm install -g intelephense
```

Can be installed in Nvim with `:LspInstall intelephense`

```lua
require'lspconfig'.intelephense.setup{}

  Commands:
  
  Default Values:
    cmd = { "intelephense", "--stdio" }
    filetypes = { "php" }
    root_dir = root_pattern("composer.json", ".git")
```

## jdtls

https://projects.eclipse.org/projects/eclipse.jdt.ls

Language server can be installed with `:LspInstall jdtls`

Language server for Java.
    
Can be installed in Nvim with `:LspInstall jdtls`

```lua
require'lspconfig'.jdtls.setup{}

  Commands:
  
  Default Values:
    handlers = {
      ["textDocument/codeAction"] = <function 1>
    }
    filetypes = { "java" }
    init_options = {
      jvm_args = {},
      workspace = "/home/runner/workspace"
    }
    root_dir = root_pattern(".git")
```

## jedi_language_server

https://github.com/pappasam/jedi-language-server

`jedi-language-server`, a language server for Python, built on top of jedi
    

```lua
require'lspconfig'.jedi_language_server.setup{}

  Commands:
  
  Default Values:
    cmd = { "jedi-language-server" }
    filetypes = { "python" }
    root_dir = vim's starting directory
```

## jsonls

https://github.com/vscode-langservers/vscode-json-languageserver

vscode-json-languageserver, a language server for JSON and JSON schema

`vscode-json-languageserver` can be installed via `:LspInstall jsonls` or by yourself with `npm`:
```sh
npm install -g vscode-json-languageserver
```

Can be installed in Nvim with `:LspInstall jsonls`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`json.colorDecorators.enable`**: `boolean`

  Default: `true`
  
  \%json\.colorDecorators\.enable\.desc\%

- **`json.format.enable`**: `boolean`

  Default: `true`
  
  \%json\.format\.enable\.desc\%

- **`json.maxItemsComputed`**: `number`

  Default: `5000`
  
  \%json\.maxItemsComputed\.desc\%

- **`json.schemaDownload.enable`**: `boolean`

  Default: `true`
  
  \%json\.enableSchemaDownload\.desc\%

- **`json.schemas`**: `array`

  Array items: `{default = {fileMatch = { "/myfile" },url = "schemaURL"},properties = {fileMatch = {description = "%json.schemas.fileMatch.desc%",items = {default = "MyFile.json",description = "%json.schemas.fileMatch.item.desc%",type = "string"},minItems = 1,type = "array"},schema = {["$ref"] = "http://json-schema.org/draft-07/schema#",description = "%json.schemas.schema.desc%"},url = {default = "/user.schema.json",description = "%json.schemas.url.desc%",type = "string"}},type = "object"}`
  
  \%json\.schemas\.desc\%

- **`json.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  \%json\.tracing\.desc\%

</details>

```lua
require'lspconfig'.jsonls.setup{}

  Commands:
  
  Default Values:
    cmd = { "vscode-json-languageserver", "--stdio" }
    filetypes = { "json" }
    root_dir = root_pattern(".git", vim.fn.getcwd())
```

## julials

https://github.com/julia-vscode/julia-vscode
`LanguageServer.jl` can be installed via `:LspInstall julials` or by yourself the `julia` and `Pkg`:
```sh
julia --project=/home/runner/.cache/nvim/lspconfig/julials -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'
```
If you want to install the LanguageServer manually, you will have to ensure that the Julia environment is stored in this location:
```vim
:lua print(require'lspconfig'.util.path.join(require'lspconfig'.util.base_install_dir, "julials"))
```
    
Can be installed in Nvim with `:LspInstall julials`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`julia.NumThreads`**: `integer|null`

  Default: `vim.NIL`
  
  Number of threads to use for Julia processes\.

- **`julia.additionalArgs`**: `array`

  Default: `{}`
  
  Additional julia arguments\.

- **`julia.enableCrashReporter`**: `boolean|null`

  Default: `vim.NIL`
  
  Enable crash reports to be sent to the julia VS Code extension developers\.

- **`julia.enableTelemetry`**: `boolean|null`

  Default: `vim.NIL`
  
  Enable usage data and errors to be sent to the julia VS Code extension developers\.

- **`julia.environmentPath`**: `string|null`

  Default: `vim.NIL`
  
  Path to a julia environment\.

- **`julia.executablePath`**: `string`

  Default: `""`
  
  Points to the julia executable\.

- **`julia.execution.codeInREPL`**: `boolean`

  Print executed code in REPL and append it to the REPL history\.

- **`julia.execution.resultType`**: `enum { "REPL", "inline", "both" }`

  Default: `"REPL"`
  
  Specifies how to show inline execution results

- **`julia.format.calls`**: `boolean`

  Default: `true`
  
  Format function calls\.

- **`julia.format.comments`**: `boolean`

  Default: `true`
  
  Format comments\.

- **`julia.format.curly`**: `boolean`

  Default: `true`
  
  Format braces\.

- **`julia.format.docs`**: `boolean`

  Default: `true`
  
  Format inline documentation\.

- **`julia.format.indent`**: `integer`

  Default: `4`
  
  Indent size for formatting\.

- **`julia.format.indents`**: `boolean`

  Default: `true`
  
  Format file indents\.

- **`julia.format.iterOps`**: `boolean`

  Default: `true`
  
  Format loop iterators\.

- **`julia.format.keywords`**: `bool`

  Default: `true`
  
  Ensure single spacing following keywords\.

- **`julia.format.kwarg`**: `enum { "none", "single", "off" }`

  Default: `"none"`
  
  Format whitespace around function keyword arguments\.

- **`julia.format.ops`**: `boolean`

  Default: `true`
  
  Format whitespace around operators\.

- **`julia.format.tuples`**: `boolean`

  Default: `true`
  
  Format tuples\.

- **`julia.lint.call`**: `boolean`

  Default: `true`
  
  This compares  call signatures against all known methods for the called function\. Calls with too many or too few arguments\, or unknown keyword parameters are highlighted\.

- **`julia.lint.constif`**: `boolean`

  Default: `true`
  
  Check for constant conditionals in if statements that result in branches never being reached\.\.

- **`julia.lint.datadecl`**: `boolean`

  Default: `true`
  
  Check variables used in type declarations are datatypes\.

- **`julia.lint.disabledDirs`**: `array`

  Default: `{ "docs", "test" }`
  
  null

- **`julia.lint.iter`**: `boolean`

  Default: `true`
  
  Check iterator syntax of loops\. Will identify\, for example\, attempts to iterate over single values\.

- **`julia.lint.lazy`**: `boolean`

  Default: `true`
  
  Check for deterministic lazy boolean operators\.

- **`julia.lint.missingrefs`**: `enum { "none", "symbols", "all" }`

  Default: `"none"`
  
  Highlight unknown symbols\. The \`symbols\` option will not mark unknown fields\.

- **`julia.lint.modname`**: `boolean`

  Default: `true`
  
  Check submodule names do not shadow their parent\'s name\.

- **`julia.lint.nothingcomp`**: `boolean`

  Default: `true`
  
  Check for use of \`\=\=\` rather than \`\=\=\=\` when comparing against \`nothing\`\. 

- **`julia.lint.pirates`**: `boolean`

  Default: `true`
  
  Check for type piracy \- the overloading of external functions with methods specified for external datatypes\. \'External\' here refers to imported code\.

- **`julia.lint.run`**: `boolean`

  Default: `true`
  
  Run the linter on active files\.

- **`julia.lint.typeparam`**: `boolean`

  Default: `true`
  
  Check parameters declared in \`where\` statements or datatype declarations are used\.

- **`julia.lint.useoffuncargs`**: `boolean`

  Default: `true`
  
  Check that all declared arguments are used within the function body\.

- **`julia.packageServer`**: `string`

  Default: `""`
  
  Julia package server\. Set\'s the \`JULIA\_PKG\_SERVER\` environment variable \*before\* starting a Julia process\. Leave this empty to use the systemwide default\. Requires a restart of the Julia process\.

- **`julia.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Traces the communication between VS Code and the language server\.

- **`julia.useCustomSysimage`**: `boolean`

  Use an existing custom sysimage when starting the REPL

- **`julia.usePlotPane`**: `boolean`

  Default: `true`
  
  Display plots within vscode\.

- **`julia.useRevise`**: `boolean`

  Default: `true`
  
  Load Revise\.jl on startup of the REPL\.

</details>

```lua
require'lspconfig'.julials.setup{}

  Commands:
  
  Default Values:
    cmd = { "julia", "--project=/home/runner/.cache/nvim/lspconfig/julials", "--startup-file=no", "--history-file=no", "-e", '        using Pkg;\n        Pkg.instantiate()\n        using LanguageServer; using SymbolServer;\n        depot_path = get(ENV, "JULIA_DEPOT_PATH", "")\n        project_path = dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))\n        # Make sure that we only load packages from this environment specifically.\n        empty!(LOAD_PATH)\n        push!(LOAD_PATH, "@")\n        @info "Running language server" env=Base.load_path()[1] pwd() project_path depot_path\n        server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);\n        server.runlinter = true;\n        run(server);\n        ' }
    filetypes = { "julia" }
    root_dir = <function 1>
```

## kotlin_language_server

    A kotlin language server which was developed for internal usage and
    released afterwards. Maintaining is not done by the original author,
    but by fwcd.

    It is builded via gradle and developed on github.
    Source and additional description:
    https://github.com/fwcd/kotlin-language-server
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`kotlin.compiler.jvm.target`**: `string`

  Default: `"default"`
  
  Specifies the JVM target\, e\.g\. \"1\.6\" or \"1\.8\"

- **`kotlin.completion.snippets.enabled`**: `boolean`

  Default: `true`
  
  Specifies whether code completion should provide snippets \(true\) or plain\-text items \(false\)\.

- **`kotlin.debounceTime`**: `integer`

  Default: `250`
  
  \[DEPRECATED\] Specifies the debounce time limit\. Lower to increase responsiveness at the cost of possibile stability issues\.

- **`kotlin.debugAdapter.enabled`**: `boolean`

  Default: `true`
  
  \[Recommended\] Specifies whether the debug adapter should be used\. When enabled a debugger for Kotlin will be available\.

- **`kotlin.debugAdapter.path`**: `string`

  Default: `""`
  
  Optionally a custom path to the debug adapter executable\.

- **`kotlin.externalSources.autoConvertToKotlin`**: `boolean`

  Default: `true`
  
  Specifies whether decompiled\/external classes should be auto\-converted to Kotlin\.

- **`kotlin.externalSources.useKlsScheme`**: `boolean`

  Default: `true`
  
  \[Recommended\] Specifies whether URIs inside JARs should be represented using the \'kls\'\-scheme\.

- **`kotlin.languageServer.debugAttach.autoSuspend`**: `boolean`

  \[DEBUG\] If enabled \(together with debugAttach\.enabled\)\, the language server will not immediately launch but instead listen on the specified attach port and wait for a debugger\. This is ONLY useful if you need to debug the language server ITSELF\.

- **`kotlin.languageServer.debugAttach.enabled`**: `boolean`

  \[DEBUG\] Whether the language server should listen for debuggers\, i\.e\. be debuggable while running in VSCode\. This is ONLY useful if you need to debug the language server ITSELF\.

- **`kotlin.languageServer.debugAttach.port`**: `integer`

  Default: `5005`
  
  \[DEBUG\] If transport is stdio this enables you to attach to the running langugage server with a debugger\. This is ONLY useful if you need to debug the language server ITSELF\.

- **`kotlin.languageServer.enabled`**: `boolean`

  Default: `true`
  
  \[Recommended\] Specifies whether the language server should be used\. When enabled the extension will provide code completions and linting\, otherwise just syntax highlighting\. Might require a reload to apply\.

- **`kotlin.languageServer.path`**: `string`

  Default: `""`
  
  Optionally a custom path to the language server executable\.

- **`kotlin.languageServer.port`**: `integer`

  Default: `0`
  
  The port to which the client will attempt to connect to\. A random port is used if zero\. Only used if the transport layer is TCP\.

- **`kotlin.languageServer.transport`**: `enum { "stdio", "tcp" }`

  Default: `"stdio"`
  
  The transport layer beneath the language server protocol\. Note that the extension will launch the server even if a TCP socket is used\.

- **`kotlin.linting.debounceTime`**: `integer`

  Default: `250`
  
  \[DEBUG\] Specifies the debounce time limit\. Lower to increase responsiveness at the cost of possibile stability issues\.

- **`kotlin.snippetsEnabled`**: `boolean`

  Default: `true`
  
  \[DEPRECATED\] Specifies whether code completion should provide snippets \(true\) or plain\-text items \(false\)\.

- **`kotlin.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Traces the communication between VSCode and the Kotlin language server\.

</details>

```lua
require'lspconfig'.kotlin_language_server.setup{}

  Commands:
  
  Default Values:
    cmd = { "kotlin-language-server" }
    filetypes = { "kotlin" }
    root_dir = root_pattern("settings.gradle")
```

## leanls

https://github.com/leanprover/lean-client-js/tree/master/lean-language-server

Lean language server.
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`lean.executablePath`**: `string`

  Default: `"lean"`
  
  Path to the Lean executable to use\. DO NOT CHANGE from the default \`lean\` unless you know what you\'re doing\!

- **`lean.extraOptions`**: `array`

  Default: `{}`
  
  Array items: `{description = "a single command-line argument",type = "string"}`
  
  Extra command\-line options for the Lean server\.

- **`lean.infoViewAllErrorsOnLine`**: `boolean`

  Info view\: show all errors on the current line\, instead of just the ones on the right of the cursor\.

- **`lean.infoViewAutoOpen`**: `boolean`

  Default: `true`
  
  Info view\: open info view when Lean extension is activated\.

- **`lean.infoViewAutoOpenShowGoal`**: `boolean`

  Default: `true`
  
  Info view\: auto open shows goal and messages for the current line \(instead of all messages for the whole file\)

- **`lean.infoViewFilterIndex`**: `number`

  Default: `-1`
  
  Index of the filter applied to the tactic state \(in the array infoViewTacticStateFilters\)\. An index of \-1 means no filter is applied\.

- **`lean.infoViewStyle`**: `string`

  Default: `""`
  
  Add an additional CSS snippet to the info view\.

- **`lean.infoViewTacticStateFilters`**: `array`

  Default: `{ {flags = "",match = false,regex = "^_"}, {flags = "",match = true,name = "goals only",regex = "^(⊢|\\d+ goals|case|$)"} }`
  
  Array items: `{description = "an object with required properties 'regex': string, 'match': boolean, and 'flags': string, and optional property 'name': string",properties = {flags = {description = "additional flags passed to the RegExp constructor, e.g. 'i' for ignore case",type = "string"},match = {description = "whether tactic state lines matching the value of 'regex' should be included (true) or excluded (false)",type = "boolean"},name = {description = "name displayed in the dropdown",type = "string"},regex = {description = "a properly-escaped regex string, e.g. '^_' matches any string beginning with an underscore",type = "string"}},required = { "regex", "match", "flags" },type = "object"}`
  
  An array of objects containing regular expression strings that can be used to filter \(positively or negatively\) the tactic state in the info view\. Set to an empty array \'\[\]\' to hide the filter select dropdown\.
   
   Each object must contain the following keys\: \'regex\'\: string\, \'match\'\: boolean\, \'flags\'\: string\.
   \'regex\' is a properly\-escaped regex string\,
   \'match\' \= true \(false\) means blocks in the tactic state matching \'regex\' will be included \(excluded\) in the info view\, 
   \'flags\' are additional flags passed to the JavaScript RegExp constructor\.
   The \'name\' key is optional and may contain a string that is displayed in the dropdown instead of the full regex details\.

- **`lean.input.customTranslations`**: `object`

  Default: `vim.empty_dict()`
  
  Array items: `{description = "Unicode character to translate to",type = "string"}`
  
  Add additional input Unicode translations\. Example\: \`\{\"foo\"\: \"☺\"\}\` will correct \`\\foo\` to \`☺\`\.

- **`lean.input.enabled`**: `boolean`

  Default: `true`
  
  Enable Lean input mode\.

- **`lean.input.languages`**: `array`

  Default: `{ "lean" }`
  
  Array items: `{description = "the name of a language, e.g. 'lean', 'markdown'",type = "string"}`
  
  Enable Lean Unicode input in other file types\.

- **`lean.input.leader`**: `string`

  Default: `"\\"`
  
  Leader key to trigger input mode\.

- **`lean.leanpkgPath`**: `string`

  Default: `"leanpkg"`
  
  Path to the leanpkg executable to use\. DO NOT CHANGE from the default \`leanpkg\` unless you know what you\'re doing\!

- **`lean.memoryLimit`**: `number`

  Default: `4096`
  
  Set a memory limit \(in megabytes\) for the Lean server\.

- **`lean.progressMessages`**: `boolean`

  Show error messages where Lean is still checking\.

- **`lean.roiModeDefault`**: `string`

  Default: `"visible"`
  
  Set the default region of interest mode \(nothing\, visible\, lines\, linesAndAbove\, open\, or project\) for the Lean extension\.

- **`lean.timeLimit`**: `number`

  Default: `100000`
  
  Set a deterministic timeout \(it is approximately the maximum number of memory allocations in thousands\) for the Lean server\.

- **`lean.typeInStatusBar`**: `boolean`

  Default: `true`
  
  Show the type of term under the cursor in the status bar\.

- **`lean.typesInCompletionList`**: `boolean`

  Display types of all items in the list of completions\. By default\, only the type of the highlighted item is shown\.

</details>

```lua
require'lspconfig'.leanls.setup{}

  Commands:
  
  Default Values:
    cmd = { "lean-language-server", "--stdio" }
    filetypes = { "lean" }
    root_dir = util.root_pattern(".git")
```

## metals

https://scalameta.org/metals/

To target a specific version on Metals, set the following.
If nothing is set, the latest stable will be used.
```vim
let g:metals_server_version = '0.8.4+106-5f2b9350-SNAPSHOT'
```

Scala language server with rich IDE features.
`metals` can be installed via `:LspInstall metals`.

Can be installed in Nvim with `:LspInstall metals`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`metals.ammoniteJvmProperties`**: `array`

  Array items: `{type = "string"}`
  
  null

- **`metals.bloopSbtAlreadyInstalled`**: `boolean`

  null

- **`metals.bloopVersion`**: `string`

  null

- **`metals.customRepositories`**: `array`

  Array items: `{type = "string"}`
  
  null

- **`metals.enableStripMarginOnTypeFormatting`**: `boolean`

  Default: `true`
  
  null

- **`metals.excludedPackages`**: `array`

  Default: `{}`
  
  null

- **`metals.gradleScript`**: `string`

  null

- **`metals.javaHome`**: `string`

  null

- **`metals.mavenScript`**: `string`

  null

- **`metals.millScript`**: `string`

  null

- **`metals.sbtScript`**: `string`

  null

- **`metals.scalafixConfigPath`**: `string`

  null

- **`metals.scalafmtConfigPath`**: `string`

  null

- **`metals.serverProperties`**: `array`

  Array items: `{type = "string"}`
  
  null

- **`metals.serverVersion`**: `string`

  Default: `"0.9.5"`
  
  null

- **`metals.showImplicitArguments`**: `boolean`

  null

- **`metals.showInferredType`**: `boolean`

  null

- **`metals.superMethodLensesEnabled`**: `boolean`

  Enable\/disable goto super method code lens\.

</details>

```lua
require'lspconfig'.metals.setup{}

  Commands:
  
  Default Values:
    cmd = { "metals" }
    filetypes = { "scala" }
    init_options = {
      compilerOptions = {
        snippetAutoIndent = false
      },
      isHttpEnabled = true,
      statusBarProvider = "show-message"
    }
    message_level = 4
    root_dir = util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml")
```

## nimls

https://github.com/PMunch/nimlsp
`nimlsp` can be installed via `:LspInstall nimls` or by yourself the `nimble` package manager:
```sh
nimble install nimlsp
```
    
Can be installed in Nvim with `:LspInstall nimls`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`nim.buildCommand`**: `string`

  Default: `"c"`
  
  Nim build command \(c\, cpp\, doc\, etc\)

- **`nim.buildOnSave`**: `boolean`

  Execute build task from tasks\.json file on save\.

- **`nim.enableNimsuggest`**: `boolean`

  Default: `true`
  
  Enable calling nimsuggest process to provide completion suggestions\, hover suggestions\, etc\.
  This option requires restart to take effect\.

- **`nim.licenseString`**: `string`

  Default: `""`
  
  Optional license text that will be inserted on nim file creation\.

- **`nim.lintOnSave`**: `boolean`

  Default: `true`
  
  Check code by using \'nim check\' on save\.

- **`nim.logNimsuggest`**: `boolean`

  Enable verbose logging of nimsuggest to use profile directory\.

- **`nim.nimprettyIndent`**: `integer`

  Default: `0`
  
  Nimpretty\: set the number of spaces that is used for indentation
  \-\-indent\:0 means autodetection \(default behaviour\)\.

- **`nim.nimprettyMaxLineLen`**: `integer`

  Default: `80`
  
  Nimpretty\: set the desired maximum line length \(default\: 80\)\.

- **`nim.nimsuggestRestartTimeout`**: `integer`

  Default: `60`
  
  Nimsuggest will be restarted after this timeout in minutes\, if 0 then restart disabled\.
  This option requires restart to take effect\.

- **`nim.project`**: `array`

  Default: `{}`
  
  Nim project file\, if empty use current selected\.

- **`nim.projectMapping`**: `object`

  Default: `vim.empty_dict()`
  
  For non project mode list of per file project mapping using regex\, for example \`\`\`\{\"\(\.\*\)\.inim\"\: \"\$1\.nim\"\}\`\`\`

- **`nim.runOutputDirectory`**: `string`

  Default: `""`
  
  Output directory for run selected file command\. The directory is relative to the workspace root\.

- **`nim.test-project`**: `string`

  Default: `""`
  
  Optional test project\.

</details>

```lua
require'lspconfig'.nimls.setup{}

  Commands:
  
  Default Values:
    cmd = { "nimlsp" }
    filetypes = { "nim" }
    root_dir = root_pattern(".git") or os_homedir
```

## ocamlls

https://github.com/ocaml-lsp/ocaml-language-server

`ocaml-language-server` can be installed via `:LspInstall ocamlls` or by yourself with `npm`
```sh
npm install -g ocaml-langauge-server
```
    
Can be installed in Nvim with `:LspInstall ocamlls`

```lua
require'lspconfig'.ocamlls.setup{}

  Commands:
  
  Default Values:
    cmd = { "ocaml-language-server", "--stdio" }
    filetypes = { "ocaml", "reason" }
    root_dir = root_pattern(".merlin", "package.json")
```

## ocamllsp

https://github.com/ocaml/ocaml-lsp

`ocaml-lsp` can be installed as described in [installation guide](https://github.com/ocaml/ocaml-lsp#installation).

To install the lsp server in a particular opam switch:
```sh
opam pin add ocaml-lsp-server https://github.com/ocaml/ocaml-lsp.git
opam install ocaml-lsp-server
```
    

```lua
require'lspconfig'.ocamllsp.setup{}

  Commands:
  
  Default Values:
    cmd = { "ocamllsp" }
    filetypes = { "ocaml", "reason" }
    root_dir = root_pattern(".merlin", "package.json")
```

## omnisharp

https://github.com/omnisharp/omnisharp-roslyn
OmniSharp server based on Roslyn workspaces

Can be installed in Nvim with `:LspInstall omnisharp`

```lua
require'lspconfig'.omnisharp.setup{}

  Commands:
  
  Default Values:
    cmd = { "/home/runner/.cache/nvim/lspconfig/omnisharp/run", "--languageserver", "--hostPID", "2529" }
    filetypes = { "cs", "vb" }
    init_options = {}
    on_new_config = <function 1>
    root_dir = root_pattern(".csproj", ".sln", ".git")
```

## purescriptls

https://github.com/nwolverson/purescript-language-server
`purescript-language-server` can be installed via `:LspInstall purescriptls` or by yourself with `npm`
```sh
npm install -g purescript-language-server
```

Can be installed in Nvim with `:LspInstall purescriptls`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`purescript.addNpmPath`**: `boolean`

  Whether to add the local npm bin directory to the PATH for purs IDE server and build command\.

- **`purescript.addPscPackageSources`**: `boolean`

  Whether to add psc\-package sources to the globs passed to the IDE server for source locations \(specifically the output of \`psc\-package sources\`\, if this is a psc\-package project\)\. Update due to adding packages\/changing package set requires psc\-ide server restart\.

- **`purescript.addSpagoSources`**: `boolean`

  Default: `true`
  
  Whether to add spago sources to the globs passed to the IDE server for source locations \(specifically the output of \`spago sources\`\, if this is a spago project\)\. Update due to adding packages\/changing package set requires psc\-ide server restart\.

- **`purescript.autoStartPscIde`**: `boolean`

  Default: `true`
  
  Whether to automatically start\/connect to purs IDE server when editing a PureScript file \(includes connecting to an existing running instance\)\. If this is disabled\, various features like autocomplete\, tooltips\, and other type info will not work until start command is run manually\.

- **`purescript.autocompleteAddImport`**: `boolean`

  Default: `true`
  
  Whether to automatically add imported identifiers when accepting autocomplete result\.

- **`purescript.autocompleteAllModules`**: `boolean`

  Default: `true`
  
  Whether to always autocomplete from all built modules\, or just those imported in the file\. Suggestions from all modules always available by explicitly triggering autocomplete\.

- **`purescript.autocompleteGrouped`**: `boolean`

  Default: `true`
  
  Whether to group completions in autocomplete results\. Requires compiler 0\.11\.6

- **`purescript.autocompleteLimit`**: `null|integer`

  Default: `vim.NIL`
  
  Maximum number of results to fetch for an autocompletion request\. May improve performance on large projects\.

- **`purescript.buildCommand`**: `string`

  Default: `"spago build --purs-args --json-errors"`
  
  Build command to use with arguments\. Not passed to shell\. eg \`pulp build \-\- \-\-json\-errors\` \(this default requires pulp \>\=10\)

- **`purescript.censorWarnings`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  The warning codes to censor\, both for fast rebuild and a full build\. Unrelated to any psa setup\. e\.g\.\: \[\"ShadowedName\"\,\"MissingTypeDeclaration\"\]

- **`purescript.codegenTargets`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  List of codegen targets to pass to the compiler for rebuild\. e\.g\. js\, corefn\. If not specified \(rather than empty array\) this will not be passed and the compiler will default to js\. Requires 0\.12\.1+

- **`purescript.editorMode`**: `boolean`

  \(DEPRECATED \- ignored from purs 0\.13\.8\) Whether to set the editor\-mode flag on the IDE server

- **`purescript.fastRebuild`**: `boolean`

  Default: `true`
  
  Enable purs IDE server fast rebuild

- **`purescript.importsPreferredModules`**: `array`

  Default: `{ "Prelude" }`
  
  Array items: `{type = "string"}`
  
  Module to prefer to insert when adding imports which have been re\-exported\. In order of preference\, most preferred first\.

- **`purescript.outputDirectory`**: `string`

  Default: `"output/"`
  
  Override purs ide output directory \(output\/ if not specified\)\. This should match up to your build command

- **`purescript.packagePath`**: `string`

  Default: `""`
  
  Path to installed packages\. Will be used to control globs passed to IDE server for source locations\.  Change requires IDE server restart\.

- **`purescript.polling`**: `boolean`

  \(DEPRECATED \- ignored from purs 0\.13\.8\) Whether to set the polling flag on the IDE server

- **`purescript.preludeModule`**: `string`

  Default: `"Prelude"`
  
  Module to consider as your default prelude\, if an auto\-complete suggestion comes from this module it will be imported unqualified\.

- **`purescript.pscIdePort`**: `integer|null`

  Default: `vim.NIL`
  
  Port to use for purs IDE server \(whether an existing server or to start a new one\)\. By default a random port is chosen \(or an existing port in \.psc\-ide\-port if present\)\, if this is specified no attempt will be made to select an alternative port on failure\.

- **`purescript.pscIdelogLevel`**: `string`

  Default: `""`
  
  Log level for purs IDE server

- **`purescript.pursExe`**: `string`

  Default: `"purs"`
  
  Location of purs executable \(resolved wrt PATH\)

- **`purescript.sourcePath`**: `string`

  Default: `"src"`
  
  Path to application source root\. Will be used to control globs passed to IDE server for source locations\. Change requires IDE server restart\.

- **`purescript.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Traces the communication between VSCode and the PureScript language service\.

</details>

```lua
require'lspconfig'.purescriptls.setup{}

  Commands:
  
  Default Values:
    cmd = { "purescript-language-server", "--stdio" }
    filetypes = { "purescript" }
    root_dir = root_pattern("spago.dhall, bower.json")
```

## pyls

https://github.com/palantir/python-language-server

`python-language-server`, a language server for Python.
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`pyls.configurationSources`**: `array`

  Default: `{ "pycodestyle" }`
  
  Array items: `{enum = { "pycodestyle", "pyflakes" },type = "string"}`
  
  List of configuration sources to use\.

- **`pyls.executable`**: `string`

  Default: `"pyls"`
  
  Language server executable

- **`pyls.plugins.jedi.env_vars`**: `dictionary`

  Default: `vim.NIL`
  
  Define environment variables for jedi\.Script and Jedi\.names\.

- **`pyls.plugins.jedi.environment`**: `string`

  Default: `vim.NIL`
  
  Define environment for jedi\.Script and Jedi\.names\.

- **`pyls.plugins.jedi.extra_paths`**: `array`

  Default: `{}`
  
  Define extra paths for jedi\.Script\.

- **`pyls.plugins.jedi_completion.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.jedi_completion.fuzzy`**: `boolean`

  Enable fuzzy when requesting autocomplete\.

- **`pyls.plugins.jedi_completion.include_class_objects`**: `boolean`

  Default: `true`
  
  Adds class objects as a separate completion item\.

- **`pyls.plugins.jedi_completion.include_params`**: `boolean`

  Default: `true`
  
  Auto\-completes methods and classes with tabstops for each parameter\.

- **`pyls.plugins.jedi_definition.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.jedi_definition.follow_builtin_imports`**: `boolean`

  Default: `true`
  
  If follow\_imports is True will decide if it follow builtin imports\.

- **`pyls.plugins.jedi_definition.follow_imports`**: `boolean`

  Default: `true`
  
  The goto call will follow imports\.

- **`pyls.plugins.jedi_hover.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.jedi_references.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.jedi_signature_help.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.jedi_symbols.all_scopes`**: `boolean`

  Default: `true`
  
  If True lists the names of all scopes instead of only the module namespace\.

- **`pyls.plugins.jedi_symbols.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.mccabe.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.mccabe.threshold`**: `number`

  Default: `15`
  
  The minimum threshold that triggers warnings about cyclomatic complexity\.

- **`pyls.plugins.preload.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.preload.modules`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  List of modules to import on startup

- **`pyls.plugins.pycodestyle.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.pycodestyle.exclude`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Exclude files or directories which match these patterns\.

- **`pyls.plugins.pycodestyle.filename`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  When parsing directories\, only check filenames matching these patterns\.

- **`pyls.plugins.pycodestyle.hangClosing`**: `boolean`

  Default: `vim.NIL`
  
  Hang closing bracket instead of matching indentation of opening bracket\'s line\.

- **`pyls.plugins.pycodestyle.ignore`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Ignore errors and warnings

- **`pyls.plugins.pycodestyle.maxLineLength`**: `number`

  Default: `vim.NIL`
  
  Set maximum allowed line length\.

- **`pyls.plugins.pycodestyle.select`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Select errors and warnings

- **`pyls.plugins.pydocstyle.addIgnore`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Ignore errors and warnings in addition to the specified convention\.

- **`pyls.plugins.pydocstyle.addSelect`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Select errors and warnings in addition to the specified convention\.

- **`pyls.plugins.pydocstyle.convention`**: `enum { "pep257", "numpy" }`

  Default: `vim.NIL`
  
  Choose the basic list of checked errors by specifying an existing convention\.

- **`pyls.plugins.pydocstyle.enabled`**: `boolean`

  Enable or disable the plugin\.

- **`pyls.plugins.pydocstyle.ignore`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Ignore errors and warnings

- **`pyls.plugins.pydocstyle.match`**: `string`

  Default: `"(?!test_).*\\.py"`
  
  Check only files that exactly match the given regular expression\; default is to match files that don\'t start with \'test\_\' but end with \'\.py\'\.

- **`pyls.plugins.pydocstyle.matchDir`**: `string`

  Default: `"[^\\.].*"`
  
  Search only dirs that exactly match the given regular expression\; default is to match dirs which do not begin with a dot\.

- **`pyls.plugins.pydocstyle.select`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Select errors and warnings

- **`pyls.plugins.pyflakes.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.pylint.args`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  Arguments to pass to pylint\.

- **`pyls.plugins.pylint.enabled`**: `boolean`

  Enable or disable the plugin\.

- **`pyls.plugins.pylint.executable`**: `string`

  Default: `vim.NIL`
  
  Executable to run pylint with\. Enabling this will run pylint on unsaved files via stdin\. Can slow down workflow\. Only works with python3\.

- **`pyls.plugins.rope_completion.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.plugins.yapf.enabled`**: `boolean`

  Default: `true`
  
  Enable or disable the plugin\.

- **`pyls.rope.extensionModules`**: `string`

  Default: `vim.NIL`
  
  Builtin and c\-extension modules that are allowed to be imported and inspected by rope\.

- **`pyls.rope.ropeFolder`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  The name of the folder in which rope stores project configurations and data\.  Pass \`null\` for not using such a folder at all\.

</details>

```lua
require'lspconfig'.pyls.setup{}

  Commands:
  
  Default Values:
    cmd = { "pyls" }
    filetypes = { "python" }
    root_dir = vim's starting directory
```

## pyls_ms

https://github.com/Microsoft/python-language-server

`python-language-server`, a language server for Python.

Requires [.NET Core](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script) to run. On Linux or macOS:

```bash
curl -L https://dot.net/v1/dotnet-install.sh | sh
```

`python-language-server` can be installed via `:LspInstall pyls_ms` or you can [build](https://github.com/microsoft/python-language-server/blob/master/CONTRIBUTING.md#setup) your own.

If you want to use your own build, set cmd to point to `Microsoft.Python.languageServer.dll`.

```lua
cmd = { "dotnet", "exec", "path/to/Microsoft.Python.languageServer.dll" };
```

If the `python` interpreter is not in your PATH environment variable, set the `InterpreterPath` and `Version` properties accordingly.

```lua
InterpreterPath = "path/to/python",
Version = "3.8"
```

This server accepts configuration via the `settings` key.

    
Can be installed in Nvim with `:LspInstall pyls_ms`

```lua
require'lspconfig'.pyls_ms.setup{}

  Commands:
  
  Default Values:
    filetypes = { "python" }
    init_options = {
      analysisUpdates = true,
      asyncStartup = true,
      displayOptions = {},
      interpreter = {
        properties = {
          InterpreterPath = "",
          Version = ""
        }
      }
    }
    on_new_config = <function 1>
    root_dir = vim's starting directory
    settings = {
      python = {
        analysis = {
          disabled = {},
          errors = {},
          info = {}
        }
      }
    }
```

## r_language_server

    [languageserver](https://github.com/REditorSupport/languageserver) is an
    implementation of the Microsoft's Language Server Protocol for the R
    language.

    It is released on CRAN and can be easily installed by

    ```R
    install.packages("languageserver")
    ```
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`r.lsp.args`**: `array`

  Default: `{}`
  
  The command line arguments to use when launching R Language Server

- **`r.lsp.debug`**: `boolean`

  Debug R Language Server

- **`r.lsp.diagnostics`**: `boolean`

  Default: `true`
  
  Enable Diagnostics

- **`r.lsp.lang`**: `string`

  Default: `""`
  
  Override default LANG environment variable

- **`r.lsp.path`**: `string`

  Default: `""`
  
  Path to R binary for launching Language Server

- **`r.lsp.use_stdio`**: `boolean`

  Use STDIO connection instead of TCP\. \(Unix\/macOS users only\)

</details>

```lua
require'lspconfig'.r_language_server.setup{}

  Commands:
  
  Default Values:
    cmd = { "R", "--slave", "-e", "languageserver::run()" }
    filetypes = { "r", "rmd" }
    log_level = 2
    root_dir = root_pattern(".git") or os_homedir
```

## rls

https://github.com/rust-lang/rls

rls, a language server for Rust

See https://github.com/rust-lang/rls#setup to setup rls itself.
See https://github.com/rust-lang/rls#configuration for rls-specific settings.

If you want to use rls for a particular build, eg nightly, set cmd as follows:

```lua
cmd = {"rustup", "run", "nightly", "rls"}
```
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`rust-client.autoStartRls`**: `boolean`

  Default: `true`
  
  Start RLS automatically when opening a file or project\.

- **`rust-client.channel`**

  Default: `"default"`
  
  Rust channel to invoke rustup with\. Ignored if rustup is disabled\. By default\, uses the same channel as your currently open project\.

- **`rust-client.disableRustup`**: `boolean`

  Disable usage of rustup and use rustc\/rls\/rust\-analyzer from PATH\.

- **`rust-client.enableMultiProjectSetup`**: `boolean|null`

  Default: `vim.NIL`
  
  Allow multiple projects in the same folder\, along with removing the constraint that the cargo\.toml must be located at the root\. \(Experimental\: might not work for certain setups\)

- **`rust-client.engine`**: `enum { "rls", "rust-analyzer" }`

  Default: `"rls"`
  
  The underlying LSP server used to provide IDE support for Rust projects\.

- **`rust-client.logToFile`**: `boolean`

  When set to true\, RLS stderr is logged to a file at workspace root level\. Requires reloading extension after change\.

- **`rust-client.revealOutputChannelOn`**: `enum { "info", "warn", "error", "never" }`

  Default: `"never"`
  
  Specifies message severity on which the output channel will be revealed\. Requires reloading extension after change\.

- **`rust-client.rlsPath`**: `string|null`

  Default: `vim.NIL`
  
  Override RLS path\. Only required for RLS developers\. If you set this and use rustup\, you should also set \`rust\-client\.channel\` to ensure your RLS sees the right libraries\. If you don\'t use rustup\, make sure to set \`rust\-client\.disableRustup\`\.

- **`rust-client.rustupPath`**: `string`

  Default: `"rustup"`
  
  Path to rustup executable\. Ignored if rustup is disabled\.

- **`rust-client.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Traces the communication between VS Code and the Rust language server\.

- **`rust-client.updateOnStartup`**: `boolean`

  Update the Rust toolchain and its required components whenever the extension starts up\.

- **`rust.all_features`**: `boolean`

  Enable all Cargo features\.

- **`rust.all_targets`**: `boolean`

  Default: `true`
  
  Checks the project as if you were running cargo check \-\-all\-targets \(I\.e\.\, check all targets and integration tests too\)\.

- **`rust.build_bin`**: `string|null`

  Default: `vim.NIL`
  
  Specify to run analysis as if running \`cargo check \-\-bin \<name\>\`\. Use \`null\` to auto\-detect\. \(unstable\)

- **`rust.build_command`**: `string|null`

  Default: `vim.NIL`
  
  EXPERIMENTAL \(requires \`unstable\_features\`\)
  If set\, executes a given program responsible for rebuilding save\-analysis to be loaded by the RLS\. The program given should output a list of resulting \.json files on stdout\. 
  Implies \`rust\.build\_on\_save\`\: true\.

- **`rust.build_lib`**: `boolean|null`

  Default: `vim.NIL`
  
  Specify to run analysis as if running \`cargo check \-\-lib\`\. Use \`null\` to auto\-detect\. \(unstable\)

- **`rust.build_on_save`**: `boolean`

  Only index the project when a file is saved and not on change\.

- **`rust.cfg_test`**: `boolean`

  Build cfg\(test\) code\. \(unstable\)

- **`rust.clear_env_rust_log`**: `boolean`

  Default: `true`
  
  Clear the RUST\_LOG environment variable before running rustc or cargo\.

- **`rust.clippy_preference`**: `enum { "on", "opt-in", "off" }`

  Default: `"opt-in"`
  
  Controls eagerness of clippy diagnostics when available\. Valid values are \(case\-insensitive\)\:
   \- \"off\"\: Disable clippy lints\.
   \- \"on\"\: Display the same diagnostics as command\-line clippy invoked with no arguments \(\`clippy\:\:all\` unless overridden\)\.
   \- \"opt\-in\"\: Only display the lints explicitly enabled in the code\. Start by adding \`\#\!\[warn\(clippy\:\:all\)\]\` to the root of each crate you want linted\.
  You need to install clippy via rustup if you haven\'t already\.

- **`rust.crate_blacklist`**: `array|null`

  Default: `{ "cocoa", "gleam", "glium", "idna", "libc", "openssl", "rustc_serialize", "serde", "serde_json", "typenum", "unicode_normalization", "unicode_segmentation", "winapi" }`
  
  Overrides the default list of packages for which analysis is skipped\.
  Available since RLS 1\.38

- **`rust.features`**: `array`

  Default: `{}`
  
  A list of Cargo features to enable\.

- **`rust.full_docs`**: `boolean|null`

  Default: `vim.NIL`
  
  Instructs cargo to enable full documentation extraction during save\-analysis while building the crate\.

- **`rust.jobs`**: `number|null`

  Default: `vim.NIL`
  
  Number of Cargo jobs to be run in parallel\.

- **`rust.no_default_features`**: `boolean`

  Do not enable default Cargo features\.

- **`rust.racer_completion`**: `boolean`

  Default: `true`
  
  Enables code completion using racer\.

- **`rust.rust-analyzer`**: `object`

  Default: `vim.empty_dict()`
  
  Settings passed down to rust\-analyzer server

- **`rust.rust-analyzer.path`**: `string|null`

  Default: `vim.NIL`
  
  When specified\, uses the rust\-analyzer binary at a given path

- **`rust.rust-analyzer.releaseTag`**: `string`

  Default: `"nightly"`
  
  Which binary release to download and use

- **`rust.rustflags`**: `string|null`

  Default: `vim.NIL`
  
  Flags added to RUSTFLAGS\.

- **`rust.rustfmt_path`**: `string|null`

  Default: `vim.NIL`
  
  When specified\, RLS will use the Rustfmt pointed at the path instead of the bundled one

- **`rust.show_hover_context`**: `boolean`

  Default: `true`
  
  Show additional context in hover tooltips when available\. This is often the type local variable declaration\.

- **`rust.show_warnings`**: `boolean`

  Default: `true`
  
  Show warnings\.

- **`rust.sysroot`**: `string|null`

  Default: `vim.NIL`
  
  \-\-sysroot

- **`rust.target`**: `string|null`

  Default: `vim.NIL`
  
  \-\-target

- **`rust.target_dir`**: `string|null`

  Default: `vim.NIL`
  
  When specified\, it places the generated analysis files at the specified target directory\. By default it is placed target\/rls directory\.

- **`rust.unstable_features`**: `boolean`

  Enable unstable features\.

- **`rust.wait_to_build`**: `number|null`

  Default: `vim.NIL`
  
  Time in milliseconds between receiving a change notification and starting build\.

</details>

```lua
require'lspconfig'.rls.setup{}

  Commands:
  
  Default Values:
    cmd = { "rls" }
    filetypes = { "rust" }
    root_dir = root_pattern("Cargo.toml")
```

## rnix

https://github.com/nix-community/rnix-lsp

A language server for Nix providing basic completion and formatting via nixpkgs-fmt.

To install manually, run `cargo install rnix-lsp`. If you are using nix, rnix-lsp is in nixpkgs.

This server accepts configuration via the `settings` key.

    
Can be installed in Nvim with `:LspInstall rnix`

```lua
require'lspconfig'.rnix.setup{}

  Commands:
  
  Default Values:
    cmd = { "rnix-lsp" }
    filetypes = { "nix" }
    init_options = {}
    on_new_config = <function 1>
    root_dir = vim's starting directory
    settings = {}
```

## rome

https://romefrontend.dev

Language server for the Rome Frontend Toolchain.

```sh
npm install [-g] rome
```


```lua
require'lspconfig'.rome.setup{}

  Commands:
  
  Default Values:
    cmd = { "rome", "lsp" }
    filetypes = { "javascript", "javascriptreact", "json", "typescript", "typescript.tsx", "typescriptreact" }
    root_dir = root_pattern('package.json', 'node_modules', '.git') or dirname
```

## rust_analyzer

https://github.com/rust-analyzer/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust

See [docs](https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user#settings) for extra settings.
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`rust-analyzer.assist.importMergeBehaviour`**: `enum { "none", "full", "last" }`

  Default: `"full"`
  
  The strategy to use when inserting new imports or merging imports\.

- **`rust-analyzer.assist.importPrefix`**: `enum { "plain", "by_self", "by_crate" }`

  Default: `"plain"`
  
  The path structure for newly inserted paths to use\.

- **`rust-analyzer.callInfo.full`**: `boolean`

  Default: `true`
  
  Show function name and docs in parameter hints

- **`rust-analyzer.cargo.allFeatures`**: `boolean`

  Activate all available features

- **`rust-analyzer.cargo.autoreload`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.cargo.features`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  List of features to activate

- **`rust-analyzer.cargo.loadOutDirsFromCheck`**: `boolean`

  null

- **`rust-analyzer.cargo.noDefaultFeatures`**: `boolean`

  null

- **`rust-analyzer.cargo.target`**: `null|string`

  Default: `vim.NIL`
  
  Specify the compilation target

- **`rust-analyzer.cargoRunner`**: `null|string`

  Default: `vim.NIL`
  
  Custom cargo runner extension ID\.

- **`rust-analyzer.checkOnSave.allFeatures`**: `null|boolean`

  Default: `vim.NIL`
  
  null

- **`rust-analyzer.checkOnSave.allTargets`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.checkOnSave.command`**: `string`

  Default: `"check"`
  
  null

- **`rust-analyzer.checkOnSave.enable`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.checkOnSave.extraArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  null

- **`rust-analyzer.checkOnSave.features`**: `null|array`

  Default: `vim.NIL`
  
  Array items: `{type = "string"}`
  
  List of features to activate\. Defaults to \`rust\-analyzer\.cargo\.features\`\.

- **`rust-analyzer.checkOnSave.noDefaultFeatures`**: `null|boolean`

  Default: `vim.NIL`
  
  null

- **`rust-analyzer.checkOnSave.overrideCommand`**: `null|array`

  Default: `vim.NIL`
  
  Array items: `{minItems = 1,type = "string"}`
  
  null

- **`rust-analyzer.checkOnSave.target`**: `null|string`

  Default: `vim.NIL`
  
  Check for a specific target\. Defaults to \`rust\-analyzer\.cargo\.target\`\.

- **`rust-analyzer.completion.addCallArgumentSnippets`**: `boolean`

  Default: `true`
  
  Whether to add argument snippets when completing functions

- **`rust-analyzer.completion.addCallParenthesis`**: `boolean`

  Default: `true`
  
  Whether to add parenthesis when completing functions

- **`rust-analyzer.completion.postfix.enable`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.debug.engine`**: `enum { "auto", "vadimcn.vscode-lldb", "ms-vscode.cpptools" }`

  Default: `"auto"`
  
  Preferred debug engine\.

- **`rust-analyzer.debug.engineSettings`**: `object`

  Default: `vim.empty_dict()`
  
  Optional settings passed to the debug engine\. Example\:
  \{ \"lldb\"\: \{ \"terminal\"\:\"external\"\} \}

- **`rust-analyzer.debug.openDebugPane`**: `boolean`

  Whether to open up the Debug Pane on debugging start\.

- **`rust-analyzer.debug.sourceFileMap`**: `object`

  Default: `{["/rustc/<id>"] = "${env:USERPROFILE}/.rustup/toolchains/<toolchain-id>/lib/rustlib/src/rust"}`
  
  Optional source file mappings passed to the debug engine\.

- **`rust-analyzer.diagnostics.disabled`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  List of rust\-analyzer diagnostics to disable

- **`rust-analyzer.diagnostics.enable`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.diagnostics.enableExperimental`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.diagnostics.warningsAsHint`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  List of warnings that should be displayed with hint severity\.
  The warnings will be indicated by faded text or three dots in code and will not show up in the problems panel\.

- **`rust-analyzer.diagnostics.warningsAsInfo`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  List of warnings that should be displayed with info severity\.
  The warnings will be indicated by a blue squiggly underline in code and a blue icon in the problems panel\.

- **`rust-analyzer.files.exclude`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Paths to exclude from analysis\.

- **`rust-analyzer.files.watcher`**: `enum { "client", "notify" }`

  Default: `"client"`
  
  Controls file watching implementation\.

- **`rust-analyzer.hoverActions.debug`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.hoverActions.enable`**: `boolean`

  Default: `true`
  
  Whether to show HoverActions in Rust files\.

- **`rust-analyzer.hoverActions.gotoTypeDef`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.hoverActions.implementations`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.hoverActions.run`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.inlayHints.chainingHints`**: `boolean`

  Default: `true`
  
  Whether to show inlay type hints for method chains\.

- **`rust-analyzer.inlayHints.enable`**: `boolean`

  Default: `true`
  
  Whether to show inlay hints

- **`rust-analyzer.inlayHints.maxLength`**: `null|integer`

  Default: `20`
  
  Maximum length for inlay hints

- **`rust-analyzer.inlayHints.parameterHints`**: `boolean`

  Default: `true`
  
  Whether to show function parameter name inlay hints at the call site\.

- **`rust-analyzer.inlayHints.typeHints`**: `boolean`

  Default: `true`
  
  Whether to show inlay type hints for variables\.

- **`rust-analyzer.lens.debug`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.lens.enable`**: `boolean`

  Default: `true`
  
  Whether to show CodeLens in Rust files\.

- **`rust-analyzer.lens.implementations`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.lens.methodReferences`**: `boolean`

  null

- **`rust-analyzer.lens.run`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.linkedProjects`**: `array`

  Default: `vim.NIL`
  
  Array items: `{type = { "string", "object" }}`
  
  null

- **`rust-analyzer.lruCapacity`**: `null|integer`

  Default: `vim.NIL`
  
  Number of syntax trees rust\-analyzer keeps in memory\.

- **`rust-analyzer.noSysroot`**: `boolean`

  null

- **`rust-analyzer.notifications.cargoTomlNotFound`**: `boolean`

  Default: `true`
  
  null

- **`rust-analyzer.procMacro.enable`**: `boolean`

  Enable Proc macro support\, cargo\.loadOutDirsFromCheck must be enabled\.

- **`rust-analyzer.runnableEnv`**

  Default: `vim.NIL`
  
  Environment variables passed to the runnable launched using \`Test \` or \`Debug\` lens or \`rust\-analyzer\.run\` command\.

- **`rust-analyzer.runnables.cargoExtraArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Additional arguments to be passed to cargo for runnables such as tests or binaries\.
  For example\, it may be \'\-\-release\'

- **`rust-analyzer.runnables.overrideCargo`**: `null|string`

  Default: `vim.NIL`
  
  Command to be executed instead of \'cargo\' for runnables\.

- **`rust-analyzer.rustcSource`**: `null|string`

  Default: `vim.NIL`
  
  Path to the rust compiler sources\, for usage in rustc\_private projects\.

- **`rust-analyzer.rustfmt.extraArgs`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Additional arguments to rustfmt

- **`rust-analyzer.rustfmt.overrideCommand`**: `null|array`

  Default: `vim.NIL`
  
  Array items: `{minItems = 1,type = "string"}`
  
  null

- **`rust-analyzer.serverPath`**: `null|string`

  Default: `vim.NIL`
  
  Path to rust\-analyzer executable \(points to bundled binary by default\)\. If this is set\, then \"rust\-analyzer\.updates\.channel\" setting is not used

- **`rust-analyzer.trace.extension`**: `boolean`

  Enable logging of VS Code extensions itself

- **`rust-analyzer.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Trace requests to the rust\-analyzer \(this is usually overly verbose and not recommended for regular users\)

- **`rust-analyzer.updates.askBeforeDownload`**: `boolean`

  Default: `true`
  
  Whether to ask for permission before downloading any files from the Internet

- **`rust-analyzer.updates.channel`**: `enum { "stable", "nightly" }`

  Default: `"stable"`
  
  null

</details>

```lua
require'lspconfig'.rust_analyzer.setup{}

  Commands:
  
  Default Values:
    cmd = { "rust-analyzer" }
    filetypes = { "rust" }
    root_dir = root_pattern("Cargo.toml", "rust-project.json")
    settings = {
      ["rust-analyzer"] = {}
    }
```

## scry

https://github.com/crystal-lang-tools/scry

Crystal language server.


```lua
require'lspconfig'.scry.setup{}

  Commands:
  
  Default Values:
    cmd = { "scry" }
    filetypes = { "crystal" }
    root_dir = root_pattern('shard.yml', '.git') or dirname
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

  Enable automatic formatting while typing \(WARNING\: experimental\)

- **`solargraph.bundlerPath`**: `string`

  Default: `"bundle"`
  
  Path to the bundle executable\, defaults to \'bundle\'\. Needs to be an absolute path for the \'bundle\' exec\/shim

- **`solargraph.checkGemVersion`**: `enum { true, false }`

  Default: `true`
  
  Automatically check if a new version of the Solargraph gem is available\.

- **`solargraph.commandPath`**: `string`

  Default: `"solargraph"`
  
  Path to the solargraph command\.  Set this to an absolute path to select from multiple installed Ruby versions\.

- **`solargraph.completion`**: `enum { true, false }`

  Default: `true`
  
  Enable completion

- **`solargraph.definitions`**: `enum { true, false }`

  Default: `true`
  
  Enable definitions \(go to\, etc\.\)

- **`solargraph.diagnostics`**: `enum { true, false }`

  Enable diagnostics

- **`solargraph.externalServer`**: `object`

  Default: `{host = "localhost",port = 7658}`
  
  The host and port to use for external transports\. \(Ignored for stdio and socket transports\.\)

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
  
  Level of debug info to log\. \`warn\` is least and \`debug\` is most\.

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
  
  The type of transport to use\.

- **`solargraph.useBundler`**: `boolean`

  Use \`bundle exec\` to run solargraph\. \(If this is true\, the solargraph\.commandPath setting is ignored\.\)

</details>

```lua
require'lspconfig'.solargraph.setup{}

  Commands:
  
  Default Values:
    cmd = { "solargraph", "stdio" }
    filetypes = { "ruby" }
    root_dir = root_pattern("Gemfile", ".git")
```

## sourcekit

https://github.com/apple/sourcekit-lsp

Language server for Swift and C/C++/Objective-C.
    
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`sourcekit-lsp.serverArguments`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Arguments to pass to sourcekit\-lsp\. Argument keys and values should be provided as separate entries in the array e\.g\. \[\'\-\-log\-level\'\, \'debug\'\]

- **`sourcekit-lsp.serverPath`**: `string`

  Default: `"sourcekit-lsp"`
  
  The path of the sourcekit\-lsp executable

- **`sourcekit-lsp.toolchainPath`**: `string`

  Default: `""`
  
  \(optional\) The path of the swift toolchain\. By default\, sourcekit\-lsp uses the toolchain it is installed in\.

- **`sourcekit-lsp.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Traces the communication between VS Code and the SourceKit\-LSP language server\.

</details>

```lua
require'lspconfig'.sourcekit.setup{}

  Commands:
  
  Default Values:
    cmd = { "xcrun", "sourcekit-lsp" }
    filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" }
    root_dir = root_pattern("Package.swift", ".git")
```

## sqlls

https://github.com/joe-re/sql-language-server

`cmd` value is **not set** by default. An installer is provided via the `:LspInstall` command that uses the *nvm_lsp node_modules* directory to find the sql-language-server executable. The `cmd` value can be overriden in the `setup` table;

```lua
require'lspconfig'.sqlls.setup{
  cmd = {"path/to/command", "up", "--method", "stdio"};
  ...
}
```

This LSP can be installed via `:LspInstall sqlls` or with `npm`. If using LspInstall, run `:LspInstallInfo sqlls` to view installation paths. Find further instructions on manual installation of the sql-language-server at [joe-re/sql-language-server](https://github.com/joe-re/sql-language-server).
<br>
    
Can be installed in Nvim with `:LspInstall sqlls`

```lua
require'lspconfig'.sqlls.setup{}

  Commands:
  
  Default Values:
    filetypes = { "sql", "mysql" }
    root_dir = <function 1>
    settings = {}
```

## sumneko_lua

https://github.com/sumneko/lua-language-server

Lua language server. **By default, this doesn't have a `cmd` set.** This is
because it doesn't provide a global binary. We provide an installer for Linux
and macOS using `:LspInstall`.  If you wish to install it yourself, [here is a
guide](https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)).
So you should set `cmd` yourself like this.

```lua
require'lspconfig'.sumneko_lua.setup{
  cmd = {"path", "to", "cmd"};
  ...
}
```

If you install via our installer, if you execute `:LspInstallInfo sumneko_lua`, you can know `cmd` value.

Can be installed in Nvim with `:LspInstall sumneko_lua`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`Lua.awakened.cat`**: `boolean`

  Default: `true`
  
  null

- **`Lua.color.mode`**: `enum { "Grammar", "Semantic" }`

  Default: `"Semantic"`
  
  null

- **`Lua.completion.callSnippet`**: `enum { "Disable", "Both", "Replace" }`

  Default: `"Disable"`
  
  null

- **`Lua.completion.displayContext`**: `integer`

  Default: `6`
  
  null

- **`Lua.completion.enable`**: `boolean`

  Default: `true`
  
  null

- **`Lua.completion.keywordSnippet`**: `enum { "Disable", "Both", "Replace" }`

  Default: `"Replace"`
  
  null

- **`Lua.develop.debuggerPort`**: `integer`

  Default: `11412`
  
  null

- **`Lua.develop.debuggerWait`**: `boolean`

  null

- **`Lua.develop.enable`**: `boolean`

  null

- **`Lua.diagnostics.disable`**: `array`

  Array items: `{type = "string"}`
  
  null

- **`Lua.diagnostics.enable`**: `boolean`

  Default: `true`
  
  null

- **`Lua.diagnostics.globals`**: `array`

  Array items: `{type = "string"}`
  
  null

- **`Lua.diagnostics.severity`**: `object`

  null

- **`Lua.diagnostics.workspaceDelay`**: `integer`

  Default: `0`
  
  null

- **`Lua.diagnostics.workspaceRate`**: `integer`

  Default: `100`
  
  null

- **`Lua.hover.enable`**: `boolean`

  Default: `true`
  
  null

- **`Lua.hover.fieldInfer`**: `integer`

  Default: `3000`
  
  null

- **`Lua.hover.viewNumber`**: `boolean`

  Default: `true`
  
  null

- **`Lua.hover.viewString`**: `boolean`

  Default: `true`
  
  null

- **`Lua.hover.viewStringMax`**: `integer`

  Default: `1000`
  
  null

- **`Lua.intelliSense.fastGlobal`**: `boolean`

  Default: `true`
  
  null

- **`Lua.intelliSense.searchDepth`**: `integer`

  Default: `0`
  
  null

- **`Lua.runtime.path`**: `array`

  Default: `{ "?.lua", "?/init.lua", "?/?.lua" }`
  
  Array items: `{type = "string"}`
  
  null

- **`Lua.runtime.special`**: `object`

  null

- **`Lua.runtime.version`**: `enum { "Lua 5.1", "Lua 5.2", "Lua 5.3", "Lua 5.4", "LuaJIT" }`

  Default: `"Lua 5.4"`
  
  null

- **`Lua.signatureHelp.enable`**: `boolean`

  Default: `true`
  
  null

- **`Lua.workspace.ignoreDir`**: `array`

  Default: `{ ".vscode" }`
  
  Array items: `{type = "string"}`
  
  null

- **`Lua.workspace.ignoreSubmodules`**: `boolean`

  Default: `true`
  
  null

- **`Lua.workspace.library`**: `object`

  null

- **`Lua.workspace.maxPreload`**: `integer`

  Default: `1000`
  
  null

- **`Lua.workspace.preloadFileSize`**: `integer`

  Default: `100`
  
  null

- **`Lua.workspace.useGitIgnore`**: `boolean`

  Default: `true`
  
  null

</details>

```lua
require'lspconfig'.sumneko_lua.setup{}

  Commands:
  
  Default Values:
    filetypes = { "lua" }
    log_level = 2
    root_dir = root_pattern(".git") or os_homedir
```

## terraformls

https://github.com/hashicorp/terraform-ls

Terraform language server
Download a released binary from https://github.com/hashicorp/terraform-ls/releases.

This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`terraform-ls.excludeRootModules`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Per\-workspace list of module directories for the language server to exclude

- **`terraform-ls.rootModules`**: `array`

  Default: `{}`
  
  Array items: `{type = "string"}`
  
  Per\-workspace list of module directories for the language server to read

- **`terraform.languageServer`**: `object`

  Default: `{args = { "serve" },external = true,maxNumberOfProblems = 100,pathToBinary = "",["trace.server"] = "off"}`
  
  Language Server settings

</details>

```lua
require'lspconfig'.terraformls.setup{}

  Commands:
  
  Default Values:
    cmd = { "terraform-ls", "serve" }
    filetypes = { "terraform" }
    root_dir = root_pattern(".terraform", ".git")
```

## texlab

https://texlab.netlify.com/

A completion engine built from scratch for (La)TeX.

See https://texlab.netlify.com/docs/reference/configuration for configuration options.


```lua
require'lspconfig'.texlab.setup{}

  Commands:
  - TexlabBuild: Build the current buffer
  
  Default Values:
    cmd = { "texlab" }
    filetypes = { "tex", "bib" }
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

Can be installed in Nvim with `:LspInstall tsserver`

```lua
require'lspconfig'.tsserver.setup{}

  Commands:
  
  Default Values:
    cmd = { "typescript-language-server", "--stdio" }
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
    root_dir = root_pattern("package.json", "tsconfig.json", ".git")
```

## vimls


```lua
require'lspconfig'.vimls.setup{}

  Commands:
  
  Default Values:
    cmd = { "vim-language-server", "--stdio" }
    docs = {
      description = "https://github.com/iamcco/vim-language-server\n\nIf you don't want to use Nvim to install it, then you can use:\n```sh\nnpm install -g vim-language-server\n```\n"
    }
    filetypes = { "vim" }
    init_options = {
      diagnostic = {
        enable = true
      },
      indexes = {
        count = 3,
        gap = 100,
        projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
        runtimepath = true
      },
      iskeyword = "@,48-57,_,192-255,-#",
      runtimepath = "",
      suggest = {
        fromRuntimepath = true,
        fromVimruntime = true
      },
      vimruntime = ""
    }
    on_new_config = <function 1>
    root_dir = <function 1>
```

## vuels

https://github.com/vuejs/vetur/tree/master/server

Vue language server(vls)
`vue-language-server` can be installed via `:LspInstall vuels` or by yourself with `npm`:
```sh
npm install -g vls
```

Can be installed in Nvim with `:LspInstall vuels`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`vetur.completion.autoImport`**: `boolean`

  Default: `true`
  
  Include completion for module export and auto import them

- **`vetur.completion.scaffoldSnippetSources`**: `object`

  Default: `{user = "🗒️",vetur = "✌",workspace = "💼"}`
  
  Where Vetur source Scaffold Snippets from and how to indicate them\. Set a source to \"\" to disable it\.
  
  \- workspace\: \`\<WORKSPACE\>\/\.vscode\/vetur\/snippets\`\.
  \- user\: \`\<USER\-DATA\-DIR\>\/User\/snippets\/vetur\`\.
  \- vetur\: Bundled in Vetur\.
  
  The default is\:
  \`\`\`
  \"vetur\.completion\.scaffoldSnippetSources\"\: \{
    \"workspace\"\: \"💼\"\,
    \"user\"\: \"🗒️\"\,
    \"vetur\"\: \"✌\"
  \}
  \`\`\`
  
  Alternatively\, you can do\:
  
  \`\`\`
  \"vetur\.completion\.scaffoldSnippetSources\"\: \{
    \"workspace\"\: \"\(W\)\"\,
    \"user\"\: \"\(U\)\"\,
    \"vetur\"\: \"\(V\)\"
  \}
  \`\`\`
  
  Read more\: https\:\/\/vuejs\.github\.io\/vetur\/snippet\.html\.

- **`vetur.completion.tagCasing`**: `enum { "initial", "kebab" }`

  Default: `"kebab"`
  
  Casing conversion for tag completion

- **`vetur.dev.logLevel`**: `enum { "INFO", "DEBUG" }`

  Default: `"INFO"`
  
  Log level for VLS

- **`vetur.dev.vlsPath`**: `string`

  Path to vls for Vetur developers\. There are two ways of using it\. 
  
  1\. Clone vuejs\/vetur from GitHub\, build it and point it to the ABSOLUTE path of \`\/server\`\.
  2\. \`yarn global add vls\` and point Vetur to the installed location \(\`yarn global dir\` + node\_modules\/vls\)

- **`vetur.dev.vlsPort`**: `number`

  Default: `-1`
  
  The port that VLS listens to\. Can be used for attaching to the VLS Node process for debugging \/ profiling\.

- **`vetur.experimental.templateInterpolationService`**: `boolean`

  Enable template interpolation service that offers hover \/ definition \/ references in Vue interpolations\.

- **`vetur.format.defaultFormatter.css`**: `enum { "none", "prettier" }`

  Default: `"prettier"`
  
  Default formatter for \<style\> region

- **`vetur.format.defaultFormatter.html`**: `enum { "none", "prettyhtml", "js-beautify-html", "prettier" }`

  Default: `"prettier"`
  
  Default formatter for \<template\> region

- **`vetur.format.defaultFormatter.js`**: `enum { "none", "prettier", "prettier-eslint", "vscode-typescript" }`

  Default: `"prettier"`
  
  Default formatter for \<script\> region

- **`vetur.format.defaultFormatter.less`**: `enum { "none", "prettier" }`

  Default: `"prettier"`
  
  Default formatter for \<style lang\=\'less\'\> region

- **`vetur.format.defaultFormatter.postcss`**: `enum { "none", "prettier" }`

  Default: `"prettier"`
  
  Default formatter for \<style lang\=\'postcss\'\> region

- **`vetur.format.defaultFormatter.pug`**: `enum { "none", "prettier" }`

  Default: `"prettier"`
  
  Default formatter for \<template lang\=\'pug\'\> region

- **`vetur.format.defaultFormatter.sass`**: `enum { "none", "sass-formatter" }`

  Default: `"sass-formatter"`
  
  Default formatter for \<style lang\=\'sass\'\> region

- **`vetur.format.defaultFormatter.scss`**: `enum { "none", "prettier" }`

  Default: `"prettier"`
  
  Default formatter for \<style lang\=\'scss\'\> region

- **`vetur.format.defaultFormatter.stylus`**: `enum { "none", "stylus-supremacy" }`

  Default: `"stylus-supremacy"`
  
  Default formatter for \<style lang\=\'stylus\'\> region

- **`vetur.format.defaultFormatter.ts`**: `enum { "none", "prettier", "prettier-tslint", "vscode-typescript" }`

  Default: `"prettier"`
  
  Default formatter for \<script\> region

- **`vetur.format.defaultFormatterOptions`**: `object`

  Default: `{["js-beautify-html"] = {wrap_attributes = "force-expand-multiline"},prettyhtml = {printWidth = 100,singleQuote = false,sortAttributes = false,wrapAttributes = false}}`
  
  Options for all default formatters

- **`vetur.format.enable`**: `boolean`

  Default: `true`
  
  Enable\/disable the Vetur document formatter\.

- **`vetur.format.options.tabSize`**: `number`

  Default: `2`
  
  Number of spaces per indentation level\. Inherited by all formatters\.

- **`vetur.format.options.useTabs`**: `boolean`

  Use tabs for indentation\. Inherited by all formatters\.

- **`vetur.format.scriptInitialIndent`**: `boolean`

  Whether to have initial indent for \<script\> region

- **`vetur.format.styleInitialIndent`**: `boolean`

  Whether to have initial indent for \<style\> region

- **`vetur.grammar.customBlocks`**: `object`

  Default: `{docs = "md",i18n = "json"}`
  
  Mapping from custom block tag name to language name\. Used for generating grammar to support syntax highlighting for custom blocks\.

- **`vetur.languageFeatures.codeActions`**: `boolean`

  Default: `true`
  
  Whether to enable codeActions

- **`vetur.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Traces the communication between VS Code and Vue Language Server\.

- **`vetur.useWorkspaceDependencies`**: `boolean`

  Use dependencies from workspace\. Currently only for TypeScript\.

- **`vetur.validation.interpolation`**: `boolean`

  Default: `true`
  
  Validate interpolations in \<template\> region using TypeScript language service

- **`vetur.validation.script`**: `boolean`

  Default: `true`
  
  Validate js\/ts in \<script\>

- **`vetur.validation.style`**: `boolean`

  Default: `true`
  
  Validate css\/scss\/less\/postcss in \<style\>

- **`vetur.validation.template`**: `boolean`

  Default: `true`
  
  Validate vue\-html in \<template\> using eslint\-plugin\-vue

- **`vetur.validation.templateProps`**: `boolean`

  Validate props usage in \<template\> region\. Show error\/warning for not passing declared props to child components and show error for passing wrongly typed interpolation expressions

</details>

```lua
require'lspconfig'.vuels.setup{}

  Commands:
  
  Default Values:
    cmd = { "vls" }
    filetypes = { "vue" }
    init_options = {
      config = {
        css = {},
        emmet = {},
        html = {
          suggest = {}
        },
        javascript = {
          format = {}
        },
        stylusSupremacy = {},
        typescript = {
          format = {}
        },
        vetur = {
          completion = {
            autoImport = false,
            tagCasing = "kebab",
            useScaffoldSnippets = false
          },
          format = {
            defaultFormatter = {
              js = "none",
              ts = "none"
            },
            defaultFormatterOptions = {},
            scriptInitialIndent = false,
            styleInitialIndent = false
          },
          useWorkspaceDependencies = false,
          validation = {
            script = true,
            style = true,
            template = true
          }
        }
      }
    }
    root_dir = root_pattern("package.json", "vue.config.js")
```

## yamlls

https://github.com/redhat-developer/yaml-language-server

`yaml-language-server` can be installed via `:LspInstall yamlls` or by yourself with `npm`:
```sh
npm install -g yaml-language-server
```

Can be installed in Nvim with `:LspInstall yamlls`
This server accepts configuration via the `settings` key.
<details><summary>Available settings:</summary>

- **`yaml.completion`**: `boolean`

  Default: `true`
  
  Enable\/disable completion feature

- **`yaml.customTags`**: `array`

  Default: `{}`
  
  Custom tags for the parser to use

- **`yaml.format.bracketSpacing`**: `boolean`

  Default: `true`
  
  Print spaces between brackets in objects

- **`yaml.format.enable`**: `boolean`

  Default: `true`
  
  Enable\/disable default YAML formatter

- **`yaml.format.printWidth`**: `integer`

  Default: `80`
  
  Specify the line length that the printer will wrap on

- **`yaml.format.proseWrap`**: `enum { "preserve", "never", "always" }`

  Default: `"preserve"`
  
  Always\: wrap prose if it exeeds the print width\, Never\: never wrap the prose\, Preserve\: wrap prose as\-is

- **`yaml.format.singleQuote`**: `boolean`

  Use single quotes instead of double quotes

- **`yaml.hover`**: `boolean`

  Default: `true`
  
  Enable\/disable hover feature

- **`yaml.schemaStore.enable`**: `boolean`

  Default: `true`
  
  Automatically pull available YAML schemas from JSON Schema Store

- **`yaml.schemas`**: `object`

  Default: `vim.empty_dict()`
  
  Associate schemas to YAML files in the current workspace

- **`yaml.trace.server`**: `enum { "off", "messages", "verbose" }`

  Default: `"off"`
  
  Traces the communication between VSCode and the YAML language service\.

- **`yaml.validate`**: `boolean`

  Default: `true`
  
  Enable\/disable validation feature

</details>

```lua
require'lspconfig'.yamlls.setup{}

  Commands:
  
  Default Values:
    cmd = { "yaml-language-server", "--stdio" }
    filetypes = { "yaml" }
    root_dir = root_pattern(".git", vim.fn.getcwd())
```

