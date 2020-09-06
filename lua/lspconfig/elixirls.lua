local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "elixirls"
local bin_name = "elixir-ls"
local cmd = "language_server"

if vim.fn.has('mac') == 1 or vim.fn.has('unix') == 1 then
    cmd = cmd..".sh"
elseif vim.fn.has('win32') == 1  or vim.fn.has('win64') == 1 then
    cmd = cmd..".bat"
else
    error("System is not supported, try to install manually.")
    return
end

local function make_installer()
    local P = util.path.join
    local install_dir = P{util.base_install_dir, server_name}
	local cmd_path = P{install_dir, bin_name, "release", cmd}

    local X = {}
    function X.install()
        local install_info = X.info()
        if install_info.is_installed then
            print(server_name, "is already installed.")
            return
        end

        if not (util.has_bins("elixir") and util.has_bins("erl")) then
            error("Need elixir and erl to install this")
            return
        end

        local script = [=[
            set -e

            # clone project
            git clone https://github.com/elixir-lsp/elixir-ls
            cd elixir-ls

            # fetch dependencies and compile
            mix deps.get && mix compile

            # install executable
            mix elixir_ls.release -o release
        ]=]
        vim.fn.mkdir(install_info.install_dir, "p")
        util.sh(script, install_info.install_dir)
    end

    function X.info()
        return {
            is_installed = util.path.exists(cmd_path);
            install_dir = install_dir;
            cmd = { cmd_path };
        }
    end

    function X.configure(config)
        local install_info = X.info()
        if install_info.is_installed then
            config.cmd = install_info.cmd
        end
    end
    return X
end

local installer = make_installer()

configs[server_name] = {
  default_config = {
    cmd = { cmd };
    filetypes = {"elixir", "eelixir"};
    root_dir = function(fname)
        return util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
    end;
    };
    on_new_config = function(config)
        installer.configure(config)
    end;
    docs = {
        package_json = "https://raw.githubusercontent.com/JakeBecker/vscode-elixir-ls/master/package.json";
        description = [[
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
]];
            default_config = {
                root_dir = [[root_pattern("mix.exs", ".git") or vim.loop.os_homedir()]];
            };
    };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
