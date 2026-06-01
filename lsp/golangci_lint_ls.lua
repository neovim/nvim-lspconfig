---@brief
---
--- Combination of both lint server and client
---
--- https://github.com/nametake/golangci-lint-langserver
--- https://github.com/golangci/golangci-lint
---
---
--- Installation of binaries needed is done via
---
--- ```
--- go install github.com/nametake/golangci-lint-langserver@latest
--- go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
--- ```

--- @class go_dir_args
---
--- @field envvar_id string
---
--- @field subdir string?

---@param dir_args go_dir_args
---@return string?
local function get_go_dir(dir_args)
  local cmd = { 'go', 'env', dir_args.envvar_id }
  local ok, sys_obj = pcall(vim.system, cmd, { text = true })

  -- handles case when go is not installed on user machine
  if not ok then
    vim.schedule(function()
      vim.notify(
        ('[golangci_lint_ls] cmd %s failed with error %s'):format(vim.inspect(cmd), vim.inspect(sys_obj)),
        vim.log.levels.ERROR
      )
    end)

    return nil
  end

  local output = sys_obj:wait()
  local res = vim.trim(output.stdout or '')

  -- handles case when go env cmd failed or res is an empty string
  if output.code ~= 0 or res == '' then
    vim.schedule(function()
      vim.notify(
        ('[golangci_lint_ls] get ' .. dir_args.envvar_id .. ' dir cmd failed with code %d: %s\n%s'):format(
          output.code,
          vim.inspect(cmd),
          output.stderr
        ),
        vim.log.levels.WARN
      )
    end)

    return nil
  end

  if dir_args.subdir and dir_args.subdir ~= '' then
    res = vim.fs.joinpath(res, dir_args.subdir)
  end

  return res
end

---@type vim.lsp.Config
return {
  cmd = { 'golangci-lint-langserver' },
  filetypes = { 'go', 'gomod' },
  init_options = {
    command = {
      'golangci-lint',
      'run',
      -- disable all output formats that might be enabled by the users .golangci.yml
      '--output.text.path=',
      '--output.tab.path=',
      '--output.html.path=',
      '--output.checkstyle.path=',
      '--output.junit-xml.path=',
      '--output.teamcity.path=',
      '--output.sarif.path=',
      -- disable stats output
      '--show-stats=false',
      -- enable JSON output to be used by the language server
      '--output.json.path=stdout',
    },
  },
  reuse_client = function(client, config)
    if client.name ~= config.name or client:is_stopped() then
      return false
    end

    if client.root_dir ~= config.root_dir then
      local mod_cache = get_go_dir({ envvar_id = 'GOMODCACHE' })
      local std_lib = get_go_dir({ envvar_id = 'GOROOT', subdir = 'src' })

      -- reuse client if config root dir is equal to go mod cache dir, or go standard library dir
      return config.root_dir == mod_cache or config.root_dir == std_lib
    end

    return true
  end,
  root_markers = {
    '.golangci.yml',
    '.golangci.yaml',
    '.golangci.toml',
    '.golangci.json',
    'go.work',
    'go.mod',
    '.git',
  },
  before_init = function(_, config)
    -- Add support for golangci-lint V1 (in V2 `--out-format=json` was replaced by
    -- `--output.json.path=stdout`).

    if vim.fn.executable('golangci-lint') ~= 1 then
      return
    end

    local v1, v2 = false, false
    -- PERF: `golangci-lint version` is very slow (about 0.1 sec) so let's find
    -- version using `go version -m $(which golangci-lint) | grep '^\smod'`.
    if vim.fn.executable 'go' == 1 then
      local exe = vim.fn.exepath 'golangci-lint'
      local version = vim.system({ 'go', 'version', '-m', exe }):wait()
      v1 = string.match(version.stdout, '\tmod\tgithub.com/golangci/golangci%-lint\t')
      v2 = string.match(version.stdout, '\tmod\tgithub.com/golangci/golangci%-lint/v2\t')
    end
    if not v1 and not v2 then
      local version = vim.system({ 'golangci-lint', 'version' }):wait()
      v1 = string.match(version.stdout, 'version v?1%.')
    end
    if v1 then
      config.init_options.command = { 'golangci-lint', 'run', '--out-format', 'json' }
    end
  end,
}
