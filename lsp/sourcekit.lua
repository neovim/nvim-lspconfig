---@brief
---
--- https://github.com/swiftlang/sourcekit-lsp
---
--- Language server for Swift and C/C++/Objective-C.

return {
  cmd = { 'sourcekit-lsp' },
  filetypes = { 'swift', 'objc', 'objcpp', 'c', 'cpp' },
  root_dir = function(bufnr, on_dir)
    on_dir(
      vim.fs.root(bufnr, 'buildServer.json')
        or vim.fs.root(bufnr, function(name, _)
          local patterns = { '*.xcodeproj', '*.xcworkspace' }
          for _, pattern in ipairs(patterns) do
            if vim.glob.to_lpeg(pattern):match(name) ~= nil then
              return true
            end
          end
          return false
        end) -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
        or vim.fs.root(bufnr, { 'compile_commands.json', 'Package.swift', '.git' })
    )
  end,
  get_language_id = function(_, ftype)
    local t = { objc = 'objective-c', objcpp = 'objective-cpp' }
    return t[ftype] or ftype
  end,
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
        relatedDocumentSupport = true,
      },
    },
  },
}
