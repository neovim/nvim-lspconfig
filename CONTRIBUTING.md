# Requirements

- Neovim :P
- docgen requires a unix system.
- luacheck for linting Lua code. ([Install](https://github.com/mpeterv/luacheck#installation))

# Generating docs

> NOTE: Github Actions automatically generates the docs, so only modify
> `README_template.md` or the `docs` object on the server config!
> **DO NOT MODIFY `README.md` DIRECTLY**

To preview the generated `README.md` locally, source `scripts/docgen.lua` from
`nvim` (e.g. with `:luafile`):

    nvim -R -Es +'set rtp+=$PWD' +'luafile scripts/docgen.lua'

It **must** be run from the `.git`/project root. (TODO: try to find the `.git`
root with one of our `util.*` functions?)

# configs

configs has a `__newindex` metamethod which validates and creates
an object containing `setup()`, which can then be retrieved and modified.

In `vim.validate` parlance, this is the "spec":

```
configs.SERVER_NAME = {
  default_config = {'t'};
  on_new_config = {'f', true};
  on_attach = {'f', true};
  commands = {'t', true};
  docs = {'t', true};
}
docs = {
  description = {'s', true};
  default_config = {'t', true};
}
```

- Keys of the `docs.default_config` table match those of
  `configs.SERVER_NAME.default_config`, and can be used to specify custom
  documentation. This is useful for functions, whose docs cannot be easily
  auto-generated.
- The `commands` object is a table of `name:definition` key:value pairs, where
  `definition` is a list whose first value is a function implementing the
  command. The other table values are either array values which will be formed
  into flags for the command or special keys like `description`.

Example:

```
  commands = {
    TexlabBuild = {
      function()
        buf_build(0)
      end;
      "-range";
      description = "Build the current buffer";
    };
  };
```


After you create `configs.SERVER_NAME`, you may add arbitrary
language-specific functions to it if necessary.

Example:

    configs.texlab.buf_build = buf_build

Finally, add a `require 'nvim_lsp/SERVER_NAME'` line to `lua/nvim_lsp.lua`.

# Auto-installation

Configs may optionally provide `install()` and `install_info()` functions.
This will be recognized by `:LspInstall` and `:LspInstallInfo`.

`function install()` is the signature and it is expected that it will create
any data in `util.base_install_dir/{server_name}`.

`function install_info()` should return a table with at least `is_installed`
which indicates the current status of installation (if it is installed by us).
It can contain any other additional data that the user may find useful.

The helper function `util.npm_installer` can be used for lsps which are installed
with `npm`. See `elmls.lua`, `tsserver.lua`, or `bashls.lua` for examples.
