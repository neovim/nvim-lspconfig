local util = require 'nvim_lsp/util'
local configs = require 'nvim_lsp/configs'

configs.r_language_server = {
  default_config = {
    cmd = {"R", "--slave", "-e", "languageserver::run()"};
    filetypes = {"r", "rmd"};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    log_level = vim.lsp.protocol.MessageType.Warning;
  };
  docs = {
  package_json = "https://raw.githubusercontent.com/REditorSupport/vscode-r-lsp/master/package.json";
    description = [[
    [languageserver](https://github.com/REditorSupport/languageserver) is an
    implementation of the Microsoft's Language Server Protocol for the R
    language.

    It is released on CRAN and can be easily installed by

    ```R
    install.packages("languageserver")
    ```
    ]];
    default_config = {
      root_dir = [[root_pattern(".git") or os_homedir]]
    };
  };
}


local get_r_version = function()
  local f = io.popen([[R --version]])
  local version = f:read("*a"):match("[0-9.]+")
  f:close()

  return version
end

local install_info = function()
  local f = io.popen([[Rscript -e "'languageserver' %in% installed.packages()"]])
  local l  = f:read("*a")
  f:close()

  local status = not l:match("FALSE")

  return {
    r_version = get_r_version(),
    is_installed = status,
  }
end

local install = function()
  if not install_info().is_installed then
    local f = io.popen([[Rscript -e "install.packages('languageserver', lib=Sys.getenv('R_LIBS_USER'))"]])
    f:close()
  end
end

configs.r_language_server.install = install
configs.r_language_server.install_info = install_info
