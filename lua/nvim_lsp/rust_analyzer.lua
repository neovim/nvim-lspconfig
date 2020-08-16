local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'
local server_name = 'rust_analyzer'
local release_url = 'https://api.github.com/repos/rust-analyzer/rust-analyzer/releases/latest'
local download_url_template = 'https://github.com/rust-analyzer/rust-analyzer/releases/download/%s/rust-analyzer-%s'
local suffix = 'linux'
local bin = 'rust-analyzer'

if vim.fn.has('mac') == 1 then
  suffix = 'mac'
elseif vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  suffix = 'windows.exe'
end

local function make_installer()
  local I = {}
  local P = util.path.join
  local install_dir = P{util.base_install_dir, server_name}
  local cmd_path = P{install_dir, bin}

  local function get_release_info()
    local json_string = vim.fn.system(string.format('curl -s "%s"', release_url), install_dir)
    return vim.fn.json_decode(json_string)
  end

  function I.install()
    local install_info = I.info()
    vim.fn.mkdir(install_info.install_dir, "p")
    local release_info = get_release_info()

    local tag_name = release_info.tag_name
    local download_url = string.format(download_url_template, tag_name, suffix)
    util.sh(
      string.format(
        'echo "Starting download: %s" && ' ..
        'curl -L "%s" > rust-analyzer && ' ..
        'chmod 755 rust-analyzer && ' ..
        'echo "%s" > .rust-analyzer-tag',
      download_url, download_url, tag_name), install_info.install_dir)
  end

  function I.info()
    return {
      is_installed = util.path.exists(cmd_path);
      install_dir = install_dir;
      cmd = { cmd_path };
    }
  end

  function I.configure(_)
    local install_info = I.info()
    local tag = vim.fn.system('cat .rust-analyzer-tag', install_info.install_dir)
    local release_info = get_release_info()
    if (release_info.tag_name == tag) then
      return
    end
    local options = {"There is a new version of rust-analyzer. Would you like to update?", "1. Update", "2. Cancel"}
    local choice = vim.fn.inputlist(options)
    if (choice == 1) then
      I.install()
    end
  end
  return I
end

local installer = make_installer()

configs.rust_analyzer = {
  default_config = {
    cmd = installer.info().cmd;
    filetypes = {"rust"};
    root_dir = util.root_pattern("Cargo.toml", "rust-project.json");
    on_new_config = function(config)
      installer.configure(config)
    end;
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/rust-analyzer/rust-analyzer/master/editors/code/package.json";
    description = [[
https://github.com/rust-analyzer/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust

See [docs](https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user#settings) for extra settings.
    ]];
    default_config = {
      root_dir = [[root_pattern("Cargo.toml", "rust-project.json")]];
      on_new_config = function(config)
        installer.configure(config)
      end;
    };
  };
};
configs.rust_analyzer.install = installer.install
configs.rust_analyzer.install_info = installer.info
-- vim:et ts=2 sw=2
