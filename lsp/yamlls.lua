---@brief
---
--- https://github.com/redhat-developer/yaml-language-server
---
--- `yaml-language-server` can be installed via `yarn`:
--- ```sh
--- yarn global add yaml-language-server
--- ```
---
--- To use a schema for validation, there are three options:
---
--- 1. Add a modeline to the file. A modeline is a comment of the form:
---
--- ```
--- # yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>
--- ```
---
--- where the relative filepath is the path relative to the open yaml file, and the absolute filepath
--- is the filepath relative to the filesystem root ('/' on unix systems)
---
--- 2. Associated a schema url, relative , or absolute (to root of project, not to filesystem root) path to
--- the a glob pattern relative to the detected project root. Check `:checkhealth vim.lsp` to determine the resolved project
--- root.
---
--- ```lua
--- vim.lsp.config('yamlls', {
---   ...
---   settings = {
---     yaml = {
---       ... -- other settings. note this overrides the lspconfig defaults.
---       schemas = {
---         ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
---         ["../path/relative/to/file.yml"] = "/.github/workflows/*",
---         ["/path/from/root/of/project"] = "/.github/workflows/*",
---       },
---     },
---   }
--- })
--- ```
---
--- Currently, kubernetes is special-cased in yammls, see the following upstream issues:
--- * [#211](https://github.com/redhat-developer/yaml-language-server/issues/211).
--- * [#307](https://github.com/redhat-developer/yaml-language-server/issues/307).
---
--- To override a schema to use a specific k8s schema version (for example, to use 1.18):
---
--- ```lua
--- vim.lsp.config('yamlls', {
---   ...
---   settings = {
---     yaml = {
---       ... -- other settings. note this overrides the lspconfig defaults.
---       schemas = {
---         ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
---         ... -- other schemas
---       },
---     },
---   }
--- })
--- ```
---
--- 3. Define in .vscode/settings.json. Properties `yaml.*` and `redhat.*` are merged into `settings` before startup.
--- Comments `//` and `/* */` in that file are ignored. Supported settings:
--- https://github.com/redhat-developer/vscode-yaml/tree/ee915c0ff5164d1cf84d6369bf2f4934d52eafd4#extension-settings
--
--- ```json
--- {
---   "redhat.telemetry.enabled": false
---   "yaml.format.enable": false,
---   "yaml.schemas": {
---     "https://json.schemastore.org/github-workflow.json": "/.github/workflows/*",
---     "../path/relative/to/file.yml": "/.github/workflows/*",
---     "/path/from/root/of/project": "/.github/workflows/*"
---   },
--- }
--- ```
---
--- Change localization of the settings.json. Set `settings_files` to `nil` to skip.
--- ```lua
--- vim.lsp.config('yamlls', {
---   settings_files = { 'mysettings.jsonc' },
--- })
--- ```

-- Retrieve settings.json content
---@param absolute_path string
---@return table
local function read_settings_content(absolute_path)
  -- Missing file is fine: the user might not have .vscode/settings.json.
  -- readblob() errors when the path cannot be opened and returns the bytes as a string.
  if vim.fn.filereadable(absolute_path) == 0 then
    return {}
  end
  local ok, settings = pcall(vim.json.decode, vim.fn.readblob(absolute_path), { skip_comments = true })
  if not ok then
    vim.notify(string.format('yamlls: failed to parse file %s', absolute_path), vim.log.levels.WARN)
    return {}
  end
  if type(settings) ~= 'table' then
    vim.notify(string.format('yamlls: file is not decoded into lua table %s', absolute_path), vim.log.levels.WARN)
    return {}
  end
  return settings
end

-- Converts settings dotted keys into tables e.g. { ["yaml.format.enable"] = false } => { yaml = { format = { enable = false } } }.
-- Only `yaml.*` properties are kept. Does not support nested keys like { yaml = { "format.enable" = false } }.
---@param settings table<string, any> decoded settings file
---@return table lsp settings to merge
local function expand_settings_keys(settings)
  local result = {}
  local roots = { 'yaml', 'redhat' }
  for key, item in pairs(settings) do
    for _, name in ipairs(roots) do
      -- dotted keys are strings and must start with 'yaml.' or 'redhat.'
      if type(key) ~= 'string' or not vim.startswith(key, name .. '.') then
        continue
      end
      local parts = vim.split(key, '.', { plain = true })
      local node = result
      for i = 1, #parts - 1 do
        local part = parts[i]
        if type(node[part]) ~= 'table' then
          node[part] = {}
        end
        node = node[part]
      end
      node[parts[#parts]] = item
      break
    end
  end
  return result
end

-- Uncomment to test manually expand_settings_keys() via `nvim --clean --headless -l lsp/yamlls.lua`
-- local input = {
--   ["redhat.telemetry.enabled"] = false,
--   ["yaml.format.enable"] = false,
--   ["yaml.schemas"] = {
--     ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
--     ["../path/relative/to/file.yml"] = { "/.yaml/*", "/.other/yaml/*" }
--   },
--   ["ignore.this.yaml"] = "bar"
-- }
-- local expected = {
--   redhat = { telemetry = { enabled = false } },
--   yaml = {
--     format = { enable = false },
--     schemas = {
--       ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
--       ["../path/relative/to/file.yml"] = {
--         "/.yaml/*",
--         "/.other/yaml/*"
--       }
--     }
--   }
-- }
-- local got = expand_settings_keys(input)
-- assert(vim.deep_equal(expected, got), string.format('expected: %s\ngot: %s', vim.inspect(expected), vim.inspect(got)))

---@class YamllsSettingsFiles
---@field settings_files? string[] List of settings.json files relative to root_dir. Defaults to { '.vscode/settings.json' }

---@class YamllsVimLspConfig: vim.lsp.Config, YamllsSettingsFiles

---@class YamllsVimLspClientConfig: vim.lsp.ClientConfig, YamllsSettingsFiles

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'yaml-language-server'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' },
  root_markers = { '.git' },
  ---@type lspconfig.settings.yamlls
  settings = {
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
    -- formatting disabled by default in yaml-language-server; enable it
    yaml = { format = { enable = true } },
  },
  settings_files = { '.vscode/settings.json' },
  -- Merge yaml settings from settings_file. Settings files must be compatible with VS Code extension:
  -- https://github.com/redhat-developer/vscode-yaml/tree/ee915c0ff5164d1cf84d6369bf2f4934d52eafd4#extension-settings
  ---@param config YamllsVimLspClientConfig
  before_init = function(_, config)
    if not config.root_dir or config.root_dir == '' then
      return
    end
    if not config.settings_files then
      return
    end
    -- Process all available settings files
    for _, rel_path in ipairs(config.settings_files) do
      if type(rel_path) ~= 'string' or rel_path == '' then
        vim.notify(string.format('yamlls: settings_files has invalid entry: %s', rel_path), vim.log.levels.WARN)
        break
      end
      -- Load file settings
      local absolute_path = vim.fs.joinpath(config.root_dir, rel_path)
      local file_content = read_settings_content(absolute_path)
      local file_settings = expand_settings_keys(file_content)
      -- Merge with default and user settings
      local settings = config.settings or {}
      local root_markers = { 'yaml', 'redhat' }
      for _, name in ipairs(root_markers) do
        local current = settings[name]
        -- Satisfy type checks. Also in case user make mistake with vim.lsp.config('yamlls')
        if type(current) == 'table' then
          -- Need to merge key by key since settings was already referenced by lsp
          settings[name] = vim.tbl_deep_extend('force', current, file_settings[name] or {})
        else
          vim.notify(('yamlls: settings.%s is not a table'):format(name), vim.log.levels.WARN)
        end
      end
    end
  end,
  on_init = function(client)
    --- https://github.com/neovim/nvim-lspconfig/pull/4016
    --- Since formatting is disabled by default if you check `client:supports_method('textDocument/formatting')`
    --- during `LspAttach` it will return `false`. This hack sets the capability to `true` to facilitate
    --- autocmd's which check this capability
    client.server_capabilities.documentFormattingProvider = true
  end,
}
