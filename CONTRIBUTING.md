# Requirements

- [Neovim](https://neovim.io/) :P
- `scripts/docgen.lua` expects a unix system.
- Lint task requires [luacheck](https://github.com/mpeterv/luacheck#installation).

# Generating docs

> Note: Github Actions automatically generates the docs, so only modify
> `README_template.md` or the `docs` object on the server config.
> Don't modify `README.md` directly.

To preview the generated `README.md` locally, run `scripts/docgen.lua` from
`nvim` (from the project root):

    nvim -R -Es +'set rtp+=$PWD' +'luafile scripts/docgen.lua'

# Configs

The `configs` module is a singleton where configs are defined. In `vim.validate`
parlance here is the "spec":

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

- Keys in `docs.default_config` match those of
  `configs.SERVER_NAME.default_config`, and can be used to specify custom
  documentation. This is useful for functions, whose docs cannot be easily
  auto-generated.
- `commands` is a map of `name:definition` key:value pairs, where `definition`
  is a list whose first value is a function implementing the command and the
  rest are either array values which will be formed into flags for the command
  or special keys like `description`. Example:
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

The `configs.__newindex` metamethod consumes the config definition and returns
an object with a `setup()` method, to be invoked by users:

    require'nvim_lsp'.SERVER_NAME.setup{}

After you set `configs.SERVER_NAME` you can add arbitrary language-specific
functions to it if necessary.

Example:

    configs.texlab.buf_build = buf_build

## Auto-install

Configs may optionally provide `install()` and `install_info()` functions. This
will be discovered by `:LspInstall` and `:LspInstallInfo`.

`function install()` is the signature and it is expected that it will create
any data in `util.base_install_dir/{server_name}`.

`function install_info()` should return a table with at least `is_installed`
which indicates the current status of installation (if it is installed by us).
It can contain any other additional data that the user may find useful.

Function `util.npm_installer()` can be used for`npm`-installable language
servers. See `elmls.lua`, `tsserver.lua`, `bashls.lua` for examples.

## Lint

When you create a pull request and push commit, Github Action run luacheck automaticaly.
If you want to run luacheck on your local, you can use `make lint`.
