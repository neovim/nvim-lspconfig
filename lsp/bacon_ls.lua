---@brief
---
--- https://github.com/crisidev/bacon-ls
---
--- A Language Server Protocol wrapper for [bacon](https://dystroy.org/bacon/).
--- It offers textDocument/diagnostic and workspace/diagnostic capabilities for Rust
--- workspaces using the Bacon export locations file.
---
--- It requires `bacon` and `bacon-ls` to be installed on the system using
--- [mason.nvim](https://github.com/williamboman/mason.nvim) or manually
---
--- ```sh
--- $ cargo install --locked bacon bacon-ls
--- ```
---
--- Settings can be changed using the `init_options` dictionary:util
---
--- ```lua
--- init_options = {
---     -- Bacon export filename (default: .bacon-locations).
---     locationsFile = ".bacon-locations",
---     -- Try to update diagnostics every time the file is saved (default: true).
---     updateOnSave = true,
---     --  How many milliseconds to wait before updating diagnostics after a save (default: 1000).
---     updateOnSaveWaitMillis = 1000,
---     -- Try to update diagnostics every time the file changes (default: true).
---     updateOnChange = true,
---     -- Try to validate that bacon preferences are setup correctly to work with bacon-ls (default: true).
---     validateBaconPreferences = true,
---     -- f no bacon preferences file is found, create a new preferences file with the bacon-ls job definition (default: true).
---     createBaconPreferencesFile = true,
---     -- Run bacon in background for the bacon-ls job (default: true)
---     runBaconInBackground = true,
---     -- Command line arguments to pass to bacon running in background (default "--headless -j bacon-ls")
---     runBaconInBackgroundCommandArguments = "--headless -j bacon-ls",
---     -- How many milliseconds to wait between background diagnostics check to synchronize all open files (default: 2000).
---     synchronizeAllOpenFilesWaitMillis = 2000,
--- }
--- ```
return {
  cmd = { 'bacon-ls' },
  filetypes = { 'rust' },
  root_markers = { '.bacon-locations', 'Cargo.toml' },
  init_options = {},
}
