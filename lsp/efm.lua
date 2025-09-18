--- @brief
---
--- https://github.com/mattn/efm-langserver
---
--- General purpose Language Server that can use specified error message format generated from specified command.
---
--- Requires at minimum EFM version [v0.0.38](https://github.com/mattn/efm-langserver/releases/tag/v0.0.38) to support
--- launching the language server on single files.
---
--- Note: In order for neovim's built-in language server client to send the appropriate `languageId` to EFM, **you must
--- specify `filetypes` in your call to `vim.lsp.config`**. Otherwise the server will be launch on the `BufEnter` instead
--- of the `FileType` autocommand, and the `filetype` variable used to populate the `languageId` will not yet be set.
---
--- ```lua
--- vim.lsp.config('efm', {
---   filetypes = { 'python','cpp','lua' }
---   settings = ..., -- You must populate this according to the EFM readme
--- })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'efm-langserver', '-q'},
  root_markers = { '.git' },
  settings = {
    languages = {
      cmake = {
        {
          formatCommand = "cmake-format -",
          formatStdin = true
        },
        {
          lintCommand = "cmake-lint",
          lintFormats = {
            "%f:%l,%c: %m"
          }
        }
      },
      json = {
        {
          formatCommand = "python3 -m json.tool",
          formatStdin = true
        },
        {
          lintCommand = "python3 -m json.tool",
          lintStdin = true,
          lintIgnoreExitCode = true,
          lintFormats = {
            "%m: line %l column %c (char %r)"
          }
        }
      },
      markdown = {
        {
          formatCommand = "pandoc -f markdown -t gfm -sp --tab-stop=2",
          formatStdin = true
        }
      },
      rst = {
        {
          formatCommand = "pandoc -f rst -t rst -s --columns=79",
          formatStdin = true
        },
        {
          lintCommand = "rstcheck -",
          lintStdin = true,
          lintFormats = {
            "%f:%l: (%tNFO/1) %m",
            "%f:%l: (%tARNING/2) %m",
            "%f:%l: (%tRROR/3) %m",
            "%f:%l: (%tEVERE/4) %m"
          }
        }
      },
      sh = {
        {
          formatCommand = "shfmt",
          formatStdin = true
        },
        {
          lintCommand = "shellcheck -f gcc -x -",
          lintStdin = true,
          lintFormats = {
            "%f:%l:%c: %trror: %m",
            "%f:%l:%c: %tarning: %m",
            "%f:%l:%c: %tote: %m"
          }
        }
      },
      yaml = {
        {
          lintCommand = "yamllint -d '{extends: default, rules: {line-length: disable}}' -f parsable -",
          lintStdin = true,
          lintIgnoreExitCode = true
        }
      }
    }
  }
}
