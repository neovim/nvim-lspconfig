local util = require 'common_lsp/util'
local api, lsp = vim.api, vim.lsp

local M = {}

M.name = "texlab"

-- TODO support more of https://github.com/microsoft/vscode-languageserver-node/blob/master/protocol/src/protocol.progress.proposed.md

local default_config
default_config = {
  name = M.name;
  cmd = {"texlab"};
  filetype = {"tex", "bib"};
  log_level = lsp.protocol.MessageType.Warning;
  settings = {
    latex = {
      build = {
        args = {"-pdf", "-interaction=nonstopmode", "-synctex=1"};
        executable = "latexmk";
        onSave = false;
      }
    }
  }
}

local function setup_callbacks(config)
  config.callbacks = config.callbacks or {}

  config.callbacks["window/logMessage"] = function(err, method, params, client_id)
    if params and params.type <= config.log_level then
      lsp.builtin_callbacks[method](err, method, params, client_id)
    end
  end

  config.callbacks["workspace/configuration"] = function(err, method, params, client_id)
    if err then error(tostring(err)) end
    if not params.items then
      return {}
    end
    local result = {}
    for _, item in ipairs(params.items) do
      if item.section then
        local value = util.lookup_section(config.settings, item.section) or vim.NIL
        table.insert(result, value)
      end
    end
    return result
  end
end

-- A function to set up texlab easier.
--
-- Additionally, it sets up the following commands:
-- - TexlabBuild: builds the current buffer.
--
-- {config} is the same as |vim.lsp.add_filetype_config()|, but with some
-- additions and changes:
--
-- {name}
--   Defaults to "texlab"
--
-- {cmd}
--   Defaults to {"texlab"}
--
-- {filetype}
--   Defaults to {"tex", "bib"}
--
-- {log_level}
--   controls the level of logs to show from build processes and other
--   window/logMessage events. By default it is set to
--   vim.lsp.protocol.MessageType.Warning instead of
--   vim.lsp.protocol.MessageType.Log.
--
-- {settings}
--   The settings specified here https://texlab.netlify.com/docs/reference/configuration.
--   This is a table, and the keys are case sensitive.
--   Example: `settings = { latex = { build = { onSave = true; } } }`
function M.setup(config)
  config = vim.tbl_extend("keep", config, default_config)

  util.tbl_deep_extend(config.settings, default_config.settings)

  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  util.tbl_deep_extend(config.capabilities, {
    workspace = {
      configuration = true;
    }
  })

  setup_callbacks(config)

  config.on_attach = util.add_hook_after(config.on_attach, function(client, bufnr)
    if bufnr == api.nvim_get_current_buf() then
      M._setup_buffer()
    else
      api.nvim_command(string.format(
          "autocmd BufEnter <buffer=%d> ++once lua require'common_lsp/%s'._setup_buffer()",
          M.name,
          bufnr))
    end
  end)

  lsp.add_filetype_config(config)
end

-- Declare any commands here. You can use additional modifiers like "-range"
-- which will be added as command options. All of these commands are buffer
-- level by default.
M.commands = {
  TexlabBuild = {
    function()
      M.buf_build(0)
    end;
  };
}

function M._setup_buffer()
  -- Create the module commands
  util.create_module_commands(M.name, M.commands)
end

local texlab_build_status = vim.tbl_add_reverse_lookup {
  Success = 0;
  Error = 1;
  Failure = 2;
  Cancelled = 3;
}

function M.buf_build(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) }  }
  lsp.buf_request(bufnr, 'textDocument/build', params,
      function(err, _, result, _)
        if err then error(tostring(err)) end
        print("Build "..texlab_build_status[result.status])
      end)
end

-- bufnr isn't actually required here, but we need a valid buffer in order to
-- be able to find the client for buf_request.
-- TODO find a client by looking through buffers for a valid client?
function M.build_cancel_all(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { token = "texlab-build-*" }
  lsp.buf_request(bufnr, 'window/progress/cancel', params, function(err, method, result, client_id)
    if err then error(tostring(err)) end
    print("Cancel result", vim.inspect(result))
  end)
end

return M
-- vim:et ts=2 sw=2
