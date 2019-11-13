local api = vim.api
local validate = vim.validate
local util = require 'common_lsp/util'
local lsp = vim.lsp

local M = {}

local texlab_build_status = vim.tbl_add_reverse_lookup {
  Success = 0;
  Error = 1;
  Failure = 2;
  Cancelled = 3;
}

function M.texlab_buf_build(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) }  }
  lsp.buf_request(bufnr, 'textDocument/build', params, function(err, method, result, client_id)
    if err then error(tostring(err)) end
    print("Build "..texlab_build_status[result.status])
  end)
end

-- bufnr isn't actually required here, but we need a valid buffer in order to
-- be able to find the client for buf_request.
-- TODO find a client by looking through buffers for a valid client?
function M.texlab_build_cancel_all(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { token = "texlab-build-*" }
  lsp.buf_request(bufnr, 'window/progress/cancel', params, function(err, method, result, client_id)
    if err then error(tostring(err)) end
    print("Cancel result", vim.inspect(result))
  end)
end

-- TODO support more of https://github.com/microsoft/vscode-languageserver-node/blob/master/protocol/src/protocol.progress.proposed.md

local function lookup_configuration(config, section)
  local settings = config.texlab_settings
  for part in vim.gsplit(section, '.', true) do
    settings = settings[part]
  end
  return settings
end

local default_config
default_config = {
  name = "texlab";
  cmd = {"texlab"};
  filetype = {"tex", "bib"};
  texlab_log_level = lsp.protocol.MessageType.Warning;
  texlab_settings = {
    latex = {
      build = {
        args = {"-pdf", "-interaction=nonstopmode", "-synctex=1"};
        executable = "latexmk";
        onSave = false;
      }
    }
  }
}

local function nvim_command(command)
  validate { command = { command, 's' } }
  for line in vim.gsplit(command, "\n", true) do
    api.nvim_command(line)
  end
end

local function setup_callbacks(config)
  config.callbacks = config.callbacks or {}

  config.callbacks["window/logMessage"] = function(err, method, params, client_id)
    if params and params.type <= config.texlab_log_level then
      lsp.builtin_callbacks[method](err, method, params, client_id)
    end
  end

  -- TODO use existing callback?
  config.callbacks["workspace/configuration"] = function(err, method, params, client_id)
    if err then error(tostring(err)) end
    if not params.items then
      return {}
    end

    local result = {}
    for _, item in ipairs(params.items) do
      if item.section then
        local value = lookup_configuration(config, item.section) or vim.NIL
        print(string.format("config[%q] = %s", item.section, vim.inspect(value)))
        table.insert(result, value)
      end
    end
    return result
  end
end

function M.texlab(config)
  config = vim.tbl_extend("keep", config, default_config)

  util.tbl_deep_extend(config.texlab_settings, default_config.texlab_settings)

  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  util.tbl_deep_extend(config.capabilities, {
    workspace = {
      configuration = true;
    }
  })

  setup_callbacks(config)

  config.on_attach = util.add_hook_after(config.on_attach, function(client, bufnr)
    if bufnr == api.nvim_get_current_buf() then
      M.texlab_setup_commands()
    else
      nvim_command(string.format("autocmd BufEnter <buffer=%d> ++once lua require'common_lsp/texlab'.texlab_setup_commands()", bufnr))
    end
  end)
  lsp.add_filetype_config(config)
end

function M.texlab_setup_commands()
  nvim_command [[
    command! TexlabBuild lua require'common_lsp/texlab'.texlab_buf_build(0)
  ]]
end

return M
-- vim:et ts=2 sw=2
