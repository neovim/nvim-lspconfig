---@brief
---
--- https://github.com/genericptr/pascal-language-server
---
--- An LSP server implementation for Pascal variants that are supported by Free Pascal, including Object Pascal. It uses CodeTools from Lazarus as backend.
---
--- First set `cmd` to the Pascal lsp binary.
---
--- Customization options are passed to pasls as environment variables for example in your `.bashrc`:
--- ```bash
--- export FPCDIR='/usr/lib/fpc/src'      # FPC source directory (This is the only required option for the server to work).
--- export PP='/usr/lib/fpc/3.2.2/ppcx64' # Path to the Free Pascal compiler executable.
--- export LAZARUSDIR='/usr/lib/lazarus'  # Path to the Lazarus sources.
--- export FPCTARGET=''                   # Target operating system for cross compiling.
--- export FPCTARGETCPU='x86_64'          # Target CPU for cross compiling.
--- ```

return {
  cmd = { 'pasls' },
  filetypes = { 'pascal' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { '*.lpi', '*.lpk', '.git' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
}
