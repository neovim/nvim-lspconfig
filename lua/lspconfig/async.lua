local M = {}

function M.run(func)
  coroutine.resume(coroutine.create(function()
    local status, err = pcall(func)
    if not status then
      vim.notify(('[lspconfig] unhandled error: %s'):format(tostring(err)), vim.log.levels.WARN)
    end
  end))
end

--- @param cmd string|string[]
--- @return string[]?
function M.run_command(cmd)
  local co = assert(coroutine.running())

  local stdout = {}
  local stderr = {}
  local exit_code = nil

  local jobid = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      data = table.concat(data, '\n')
      if #data > 0 then
        stdout[#stdout + 1] = data
      end
    end,
    on_stderr = function(_, data, _)
      stderr[#stderr + 1] = table.concat(data, '\n')
    end,
    on_exit = function(_, code, _)
      exit_code = code
      coroutine.resume(co)
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  if jobid <= 0 then
    vim.notify(('[lspconfig] unable to run cmd: %s'):format(cmd), vim.log.levels.WARN)
    return nil
  end

  coroutine.yield()

  if exit_code ~= 0 then
    vim.notify(
      ('[lspconfig] cmd failed with code %d: %s\n%s'):format(exit_code, cmd, table.concat(stderr, '')),
      vim.log.levels.WARN
    )
    return nil
  end

  if next(stdout) == nil then
    return nil
  end
  return stdout and stdout or nil
end

---@param cmd string[]
---@param on_done function(string[]?)
---@param on_error? function(integer, string[]?)
function M.run_job(cmd, on_done, on_error)
  local stdout = {}
  local stderr = {}

  local jobid = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      data = table.concat(data, '\n')
      if #data > 0 then
        stdout[#stdout + 1] = data
      end
    end,
    on_stderr = function(_, data, _)
      stderr[#stderr + 1] = table.concat(data, '\n')
    end,
    on_exit = function(_, code, _)
      if code == 0 then
        on_done(stdout)
      else
        if on_error then
          on_error(code, stderr)
        else
          vim.notify(
            ('[lspconfig] cmd failed with code %d: %s\n%s'):format(code, cmd, table.concat(stderr, '')),
            vim.log.levels.WARN
          )
        end
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  if jobid <= 0 then
    vim.notify(('[lspconfig] unable to run cmd: %s'):format(cmd), vim.log.levels.WARN)
    return nil
  end
end

function M.reenter()
  if vim.in_fast_event() then
    local co = assert(coroutine.running())
    vim.schedule(function()
      coroutine.resume(co)
    end)
    coroutine.yield()
  end
end

return M
