# Requirements

- [Neovim](https://neovim.io/) :P
- `scripts/docgen.lua` expects a unix system.
- [luacheck](https://github.com/mpeterv/luacheck#installation) for the lint job.

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

The `configs.__newindex` metamethod consumes the config definition and returns
an object with a `setup()` method, to be invoked by users like so:

    require'nvim_lsp'.SERVER_NAME.setup{}

- Keys of the `docs.default_config` table match those of
  `configs.SERVER_NAME.default_config`, and can be used to specify custom
  documentation. This is useful for functions, whose docs cannot be easily
  auto-generated.

`commands` is a table of `name:definition` key:value pairs, where `definition`
is a list whose first value is a function implementing the command and the rest
are either array values which will be formed into flags for the command or
special keys like `description`.

Example:

    commands = {
      TexlabBuild = {
        function()
          buf_build(0)
        end;
        "-range";
        description = "Build the current buffer";
      };
    };

After you set `configs.SERVER_NAME`, you can add arbitrary language-specific
functions to it if necessary.

Example:

    configs.texlab.buf_build = buf_build

Finally, add a `require 'nvim_lsp/SERVER_NAME'` line to `lua/nvim_lsp.lua`.

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
