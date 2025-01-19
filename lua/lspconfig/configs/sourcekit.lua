return {
  default_config = {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift', 'objc', 'objcpp', 'c', 'cpp' },
    root_dir = function(filename, _)
      return vim.fs.dirname(vim.fs.find('buildServer.json', { path = filename, upward = true })[1])
        or vim.fs.dirname(vim.fs.find({ '*.xcodeproj', '*.xcworkspace' }, { path = filename, upward = true })[1])
        -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
        or vim.fs.dirname(
          vim.fs.find({ 'compile_commands.json', 'Package.swift' }, { path = filename, upward = true })[1]
        )
        or vim.fs.dirname(vim.fs.find({ '.git' }, { path = filename, upward = true })[1])
    end,
    get_language_id = function(_, ftype)
      local t = { objc = 'objective-c', objcpp = 'objective-cpp' }
      return t[ftype] or ftype
    end,
  },
  docs = {
    description = [[
https://github.com/apple/sourcekit-lsp

Language server for Swift and C/C++/Objective-C.
    ]],
  },
}
