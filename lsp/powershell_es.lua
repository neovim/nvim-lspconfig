--- @brief
---
--- https://github.com/PowerShell/PowerShellEditorServices
---
--- Language server for PowerShell.
---
--- To install, download and extract PowerShellEditorServices.zip
--- from the [releases](https://github.com/PowerShell/PowerShellEditorServices/releases).
--- To configure the language server, set the property `bundle_path` to the root
--- of the extracted PowerShellEditorServices.zip.
---
--- ```lua
--- vim.lsp.config('powershell_es', {
---   bundle_path = 'c:/w/PowerShellEditorServices',
--- })
--- ```
---
--- By default the language server is started in `pwsh` (PowerShell Core). This can be changed by specifying `shell`.
---
--- ```lua
--- vim.lsp.config('powershell_es', {
---   bundle_path = 'c:/w/PowerShellEditorServices',
---   shell = 'powershell.exe',
--- })
--- ```
---
--- Note that the execution policy needs to be set to `Unrestricted` for the languageserver run under PowerShell
---
--- By default, profile loading is disabled (`enableProfileLoading = false`) since the
--- language server runs as a background process, not an interactive session, and a
--- profile that writes to stdout can corrupt the LSP handshake. Override if needed:
---
--- ```lua
--- vim.lsp.config('powershell_es', {
---   init_options = { enableProfileLoading = true },
--- })
--- ```
---
--- If necessary, specific `cmd` can be defined instead of `bundle_path`.
--- See [PowerShellEditorServices](https://github.com/PowerShell/PowerShellEditorServices#standard-input-and-output)
--- to learn more.
---
--- ```lua
--- vim.lsp.config('powershell_es', {
---   cmd = {'pwsh', '-NoLogo', '-NoProfile', '-Command', "c:/PSES/Start-EditorServices.ps1 ..."},
--- })
--- ```

--- @return string[]? cmd
--- @return string? err
local function make_cmd()
  local shell = (vim.lsp.config.powershell_es.shell or 'pwsh') --[[@as string]]
  if vim.fn.executable(shell) ~= 1 then
    return nil, string.format("Executable '%s' not found in system PATH.", shell)
  end

  local bundle_path = vim.lsp.config.powershell_es.bundle_path --[[@as string]]
  if not bundle_path or bundle_path == '' then
    local module = 'PowerShellEditorServices'
    -- Let pwsh/powershell find the module path dynamically
    local find_module_cmd = string.format('(Get-Module -ListAvailable -Name %s).ModuleBase', module)

    local stdout = vim.fn.system({ shell, '-NoProfile', '-Command', find_module_cmd })

    -- vim.fn.system sets v:shell_error if it fails
    if vim.v.shell_error ~= 0 then
      return nil, string.format('Failed to look up %s module via shell.', module)
    end

    bundle_path = vim.trim(stdout or ''):gsub('\\', '/')

    if bundle_path == '' then
      return nil,
        string.format(
          "PowerShell module '%s' was not found by '%s'. Please check your $env:PSModulePath.",
          module,
          shell
        )
    end
  end

  local command_fmt =
    [[& '%s/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Information]]
  local temp_path = vim.fn.stdpath('cache')
  local command = command_fmt:format(bundle_path, bundle_path, temp_path, temp_path)

  return { shell, '-NoLogo', '-NoProfile', '-Command', command }, nil
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers)
    local cmd, err = make_cmd()
    if not cmd then
      vim.lsp.log.error(string.format('[powershell_es] %s', err))
      return nil
    end

    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
  filetypes = { 'ps1' },
  root_markers = { 'PSScriptAnalyzerSettings.psd1', '.git' },
  init_options = {
    enableProfileLoading = false,
  },
}
