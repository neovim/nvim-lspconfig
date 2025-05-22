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
return {
  cmd = { 'golangci-lint-langserver' },
  filetypes = { 'go', 'gomod' },
  init_options = {
    command = { 'golangci-lint', 'run', '--output.json.path=stdout', '--show-stats=false' },
  },
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
    local v1
    -- PERF: `golangci-lint version` is very slow (about 0.1 sec) so let's find
    -- version using `go version -m $(which golangci-lint) | grep '^\smod'`.
    if vim.fn.executable 'go' == 1 then
      local exe = vim.fn.exepath 'golangci-lint'
      local version = vim.system({ 'go', 'version', '-m', exe }):wait()
      v1 = string.match(version.stdout, '\tmod\tgithub.com/golangci/golangci%-lint\t')
    else
      local version = vim.system({ 'golangci-lint', 'version' }):wait()
      v1 = string.match(version.stdout, 'version v?1%.')
    end
    if v1 then
      config.init_options.command = { 'golangci-lint', 'run', '--out-format', 'json' }
    end
  end,
}
