local M = {}

function M.run(func)
  coroutine.resume(coroutine.create(function()
    local status, err = pcall(func)
    if not status then
      vim.notify(('[lspconfig] unhandled error: %s'):format(tostring(err)), vim.log.levels.WARN)
    end
  end))
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
