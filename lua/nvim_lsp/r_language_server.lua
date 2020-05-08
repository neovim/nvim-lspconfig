local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local function installer()
  local cmd = [[Rscript -e "install.packages('languageserver')"]]
  local f = io.popen(cmd)
  f:close()
end

configs.r_language_server = {
  default_config = {
    cmd = {"R", "--slave", "-e", "languageserver::run()"};
    filetypes = {"r", "rmd"};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    log_level = vim.lsp.protocol.MessageType.Warning;
  };
  on_new_config = function()
    installer()
  end;
}
