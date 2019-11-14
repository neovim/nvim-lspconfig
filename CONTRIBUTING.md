# Requirements

- Neovim :P
- The docgen requires \*nix systems for now.

# Generating docs

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
