local root_files = { 'configure.ac', 'Makefile', 'Makefile.am', '*.mk' }

---@brief
---
-- https://github.com/Freed-Wu/autotools-language-server
--
-- `autotools-language-server` can be installed via `pip`:
-- ```sh
-- pip install autotools-language-server
-- ```
--
-- Language server for autoconf, automake and make using tree sitter in python.
return {
  cmd = { 'autotools-language-server' },
  filetypes = { 'config', 'automake', 'make' },
  root_markers = function(name, _)
    for _, pattern in ipairs(root_files) do
      if vim.glob.to_lpeg(pattern):match(name) ~= nil then
        return true
      end
    end
    return false
  end,
}
