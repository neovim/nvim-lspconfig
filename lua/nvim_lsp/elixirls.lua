local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local server_name = "elixirls"
local bin_name = "elixir-ls"
local bin

local function make_installer()
    local P = util.path.join
    local install_dir = P{util.base_install_dir, server_name}
    local git_dir = P{install_dir, bin_name}

    if vim.fn.has('mac') == 1 or vim.fn.has('unix') == 1 then
        bin = P{git_dir, "release", "language_server.sh"}
    elseif vim.fn.has('win32') == 1  or vim.fn.has('win64') == 1 then
        bin = P{git_dir, "release", "language_server.bat"}
    else
        error("System is not supported, try to install manually.")
        return
    end

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
            bin_name=]=] .. bin_name .. '\n' ..  [=[

            # clone project
            git clone https://github.com/elixir-lsp/$bin_name
            cd $bin_name
            
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
            is_installed = util.path.exists(bin);
            install_dir = install_dir;
            cmd = { bin };
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
    cmd = {bin};
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

        Elixir language server. This LSP does not provide a language server by default, but it makes an attempt
        at installing it by cloning the git repo and compiling it using elixir's build tool Mix. This is also
        the reason for not including the `cmd` option by default. This can be set by using the following format:
        ```lua
        require'nvim_lsp'.elixirLS.setup{
            -- Unix
            cmd = {"path/to/language_server.sh"};
            -- Windows
            cmd = {"path/to/language_server.bat"};
            ...
        }
        ```

        Use `LspInstall elixirls` to install it.

        If you want to install it manually, following the instructions [here](https://github.com/elixir-lsp/elixir-ls#building-and-running)
        ]];
            default_config = {
                root_dir = [[root_pattern("mix.exs", ".git") or vim.loop.os_homedir()]];
            };
    };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
