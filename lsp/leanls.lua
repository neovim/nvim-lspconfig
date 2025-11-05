local Buffer = require 'std.nvim.buffer'
local std = require 'std.lsp'

local diagnostic = require 'lean.diagnostic'
local log = require 'lean.log'
local lsp = require 'lean.lsp'

local CONFIG = require 'lean.config'()

---A replacement handler for diagnostic publishing for Lean-specific behavior.
---
---Publishes all "silent" Lean diagnostics to a separate namespace, and creates
---unsolved goals markers (in yet another namespace).
---@param result LeanPublishDiagnosticsParams
---@param ctx lsp.HandlerContext
local function on_publish_diagnostics(_, result, ctx)
  local buffer = Buffer:from_uri(result.uri)
  vim.diagnostic.reset(lsp.silent_ns, buffer.bufnr)
  buffer:clear_namespace(lsp.goals_ns)

  local markers = CONFIG.goal_markers

  ---@type { [1]: integer, [2]: integer }[]
  local unsolved = {}
  local other_silent = {}

  result.diagnostics = vim
    .iter(result.diagnostics)
    ---@param each DiagnosticWith<string>
    :filter(function(each)
      local range = diagnostic.range_of(each)
      -- Protect setting markers with a pcall, which seems like it can happen
      -- if we're still processing diagnostics but the buffer has already
      -- changed, which can give out of range errors when setting the extmarks.
      local succeeded = pcall(function()
        if markers.unsolved ~= '' and diagnostic.is_unsolved_goals(each) then
          table.insert(unsolved, std.position_to_byte0(range['end'], buffer.bufnr))
        elseif markers.accomplished ~= '' and diagnostic.is_goals_accomplished(each) then
          local start_row, start_col, end_row, end_col = diagnostic.byterange_of(buffer.bufnr, each)
          buffer:set_extmark(lsp.goals_ns, start_row, start_col, {
            sign_text = markers.accomplished,
            sign_hl_group = 'leanGoalsAccomplishedSign',
          })
          buffer:set_extmark(lsp.goals_ns, start_row, start_col, {
            end_row = end_row,
            end_col = end_col,
            hl_group = 'leanGoalsAccomplished',
            hl_mode = 'combine',
          })
        end
      end)
      if not succeeded then
        log:debug {
          message = 'Failed to set goals accomplished markers',
          diagnostic = each,
          bufnr = buffer.bufnr,
        }
      end

      return not each.isSilent
    end)
    :totable()

  vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)

  if #unsolved ~= 0 then
    local function place_marker(pos)
      local succeeded = pcall(Buffer.set_extmark, buffer, lsp.goals_ns, pos[1], pos[2], {
        hl_mode = 'combine',
        virt_text = { { markers.unsolved, 'leanUnsolvedGoals' } },
        virt_text_pos = 'eol',
      })
      if not succeeded then
        log:debug {
          message = 'Failed to set unsolved goal marker',
          bufnr = buffer.bufnr,
        }
      end
    end

    local function place_all()
      vim.iter(unsolved):each(place_marker)
      unsolved = {} -- so we don't place 2 markers on hold + insert leave
    end

    local mode = vim.api.nvim_get_mode().mode
    if mode == 'i' then
      buffer:create_autocmd({ 'InsertLeave', 'CursorHoldI' }, {
        group = vim.api.nvim_create_augroup('LeanUnsolvedGoalsMarkers', {}),
        callback = place_all,
        once = true,
        desc = 'place unsolved goals markers',
      })
    else
      place_all()
    end
  end

  vim.diagnostic.set(
    lsp.silent_ns,
    buffer.bufnr,
    diagnostic.leanls_to_vim(other_silent, buffer.bufnr, ctx.client_id),
    {
      underline = false,
      virtual_text = false,
      update_in_insert = false,
    }
  )
end

---Called when `$/lean/fileProgress` is triggered.
---@param err LspError?
---@param params LeanFileProgressParams
local function file_progress_handler(err, params)
  if err ~= nil then
    log:error {
      message = 'fileProgress error',
      err = err,
      params = params,
    }
    return
  else
    log:trace {
      message = 'got fileProgress',
      err = err,
      params = params,
    }
  end

  require('lean.progress').update(params)
  require('lean.progress_bars').update(params)

  local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    log:warning {
      message = 'updating fileProgress for an unloaded buffer',
      bufnr = bufnr,
      err = err,
      params = params,
    }
    return
  end

  require('lean.infoview').__update_pin_by_uri(params.textDocument.uri)
end

return {
  filetypes = { 'lean' },
  ---@param dispatchers vim.lsp.rpc.Dispatchers
  ---@param config vim.lsp.ClientConfig
  cmd = function(dispatchers, config)
    -- Lean's language server does not use workspace folders, it strictly
    -- relies on the working directory that lake serve is started in.
    -- lspconfig historically had this same behavior (of using rootDir as cwd)
    -- when starting lake serve.
    local cmd_cwd = config.cmd_cwd
    if not cmd_cwd and config.root_dir and vim.uv.fs_realpath(config.root_dir) then
      cmd_cwd = config.root_dir
    end

    local local_cmd = { 'lake', 'serve', '--', config.root_dir }
    return vim.lsp.rpc.start(local_cmd, dispatchers, {
      cwd = cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    fname = vim.fs.normalize(fname)
    -- check if inside lean stdlib
    local stdlib_dir
    do
      local _, endpos = fname:find '/lean/library'
      if endpos then
        stdlib_dir = fname:sub(1, endpos)
      end
    end
    if not stdlib_dir then
      local _, endpos = fname:find '/lib/lean'
      if endpos then
        stdlib_dir = fname:sub(1, endpos)
      end
    end

    on_dir(
      vim.fs.root(fname, { 'lakefile.toml', 'lakefile.lean', 'lean-toolchain' })
        or stdlib_dir
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    )
  end,

  capabilities = {
    lean = {
      silentDiagnosticSupport = true,
    },
  },
  handlers = {
    ['$/lean/fileProgress'] = file_progress_handler,
    [vim.lsp.protocol.Methods.textDocument_publishDiagnostics] = on_publish_diagnostics,
  },
  init_options = {
    editDelay = 10, -- see #289
    hasWidgets = true,
  },
  on_init = function(_, response)
    local version = response.serverInfo.version
    ---Lean 4.19 introduces silent diagnostics, which we use to differentiate
    ---between "No goals." and "Goals accomplished. For older versions, we
    ---always say the latter (which is consistent with `lean.nvim`'s historic
    ---behavior, albeit not with VSCode's).
    ---
    ---Technically this being a global is wrong, and will mean we start
    ---showing the wrong message if someone opens an older Lean buffer in the
    ---same session as a newer one...
    vim.g.lean_no_goals_message = vim.version.ge(version, '0.3.0') and 'No goals.'
      or 'Goals accomplished 🎉'
  end,
}
