# Requirements

- Neovim :P
- The docgen requires \*nix systems for now.

# Generating docs

> NOTE: Github Actions automatically generates the docs, so only modify
> README_preamble.md or the `docs` in the server config!

The instructions here are for previewing changes locally.

`scripts/docgen.lua` was written with the intention of being sourced (like with `luafile`)
from `nvim` to run.

It **must** be run from the .git/project root. This could be modified to try to
find the .git root with one of our `util.*` functions potentially.

You can run
`nvim -u NONE +'set rtp+=$PWD' +"luafile scripts/docgen.lua" +q`
from the project root. This ensures that it doesn't pick up another
copy of `nvim_lsp` on your system.

This generates a suffix for README.md


# skeleton

skeleton has a `__newindex` metamethod which validates and creates
an object containing `setup()`, which can then be retrieved and modified.

In vim.validate parlance, this is the format to use.

```
skeleton.SERVER_NAME = {
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

The docs `default_config` is a table whose keys match the other `default_config`,
and can be used to specify a string in place of using `vim.inspect(value)` to
generate the documentation. This is useful for functions, whose output would
be unhelpful otherwise.

`commands` is a table of key/value pairs from `command_name -> {definition}`.
The format of `{definition}` is a table where the first array value
is a function which will be called for this command. The other table values
are either array values which will be formed into flags for the command or
special keys like `description`.

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


After you create a `skeleton.SERVER_NAME`, you can add functions to it that you
wish to expose to the user.

Example:

```
skeleton.texlab.buf_build = buf_build
```

After you create a skeleton, you have to `require 'nvim_lsp/SERVER_NAME'` in
`lua/nvim_lsp.lua`, and that's it.

Generate docs and you're done.

# Supporting installation

If a skeleton has the functions `.install()` and `.install_info()` available, then
it will be picked up by `LspInstall` and `LspInstallInfo`.

`function install()` is the signature and it is expected that it will create
any data in `util.base_install_dir/{server_name}`.

`function install_info()` should return a table with at least `is_installed`
which indicates the current status of installation (if it is installed by us).
It can contain any other additional data that the user may find useful.

The helper function `util.npm_installer` can be used for lsps which are installed
with `npm`. See `elmls.lua` or `tsserver.lua` or `bashls.lua` for example usage.
