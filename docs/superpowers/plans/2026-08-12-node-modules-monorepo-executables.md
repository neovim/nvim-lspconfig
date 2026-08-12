# Monorepo Node Modules Executable Discovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make every language-server config changed by PR #4386 find the nearest package-local or monorepo-hoisted `node_modules/.bin` executable without changing its LSP workspace root.

**Architecture:** Each affected modern config defines a small private `get_cmd(cmd, root_dir)` resolver because nvim-lspconfig configs must remain self-contained. The resolver finds the nearest package-manager-lockfile workspace boundary, falls back to the Git root, checks executable candidates from `root_dir` upward through that boundary, and returns the bare command when no candidate exists. Command functions retain their current arguments and RPC startup behavior.

**Tech Stack:** Lua, Neovim `vim.fs`, Neovim LSP RPC, Vusted/Busted tests, StyLua, EmmyLua

## Global Constraints

- Preserve every existing `root_dir`, `root_markers`, `workspace_required`, filetype, server argument, and server-specific command policy.
- Prefer a package-local executable over a workspace-hoisted executable.
- Search through, but never above, the nearest package-manager-lockfile workspace boundary; use the nearest Git root only when no lockfile boundary exists.
- Use lockfiles `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb`, and `bun.lock`.
- Fall back to the existing bare command when `root_dir` is nil or no local executable exists.
- Keep each config self-contained; do not add a production helper to `lua/lspconfig/util.lua` or any other frozen legacy file.
- Preserve Glint's `init_options.glint.useGlobal` behavior.
- Default to ASCII and format modified Lua with StyLua.

---

### Task 1: Specify Executable Resolution Behavior

**Files:**
- Modify: `test/lspconfig_spec.lua`
- Test: `test/lspconfig_spec.lua`

**Interfaces:**
- Consumes: Modern configs loaded with `dofile('lsp/<name>.lua')`; config command signature `cmd(dispatchers, config)`.
- Produces: A reusable test-only `capture_cmd(config, lsp_config)` helper returning the argv passed to `vim.lsp.rpc.start`, plus fixture helpers that create executable candidates and workspace markers.

- [ ] **Step 1: Add test fixture and RPC-capture helpers**

Add these helpers near the top of `test/lspconfig_spec.lua`, inside the outer `describe` after assertion aliases:

```lua
  local tempdirs = {}

  local function mkdir(path)
    vim.fn.mkdir(path, 'p')
    return path
  end

  local function touch(path)
    vim.fn.writefile({}, path)
    return path
  end

  local function executable(path)
    vim.fn.writefile({ '#!/bin/sh', 'exit 0' }, path)
    vim.fn.setfperm(path, 'rwxr-xr-x')
    return path
  end

  local function tempdir()
    local path = vim.fn.tempname()
    mkdir(path)
    table.insert(tempdirs, path)
    return path
  end

  local function capture_cmd(config, lsp_config)
    local original_start = vim.lsp.rpc.start
    local captured
    vim.lsp.rpc.start = function(cmd)
      captured = cmd
      return {}
    end
    local ok, err = pcall(config.cmd, {}, lsp_config)
    vim.lsp.rpc.start = original_start
    assert(ok, err)
    return captured
  end
```

Extend teardown so temporary directories are always deleted:

```lua
  after_each(function()
    for _, path in ipairs(tempdirs) do
      vim.fn.delete(path, 'rf')
    end
    tempdirs = {}
  end)
```

- [ ] **Step 2: Add failing package-local and hoisted-executable tests**

Add a new `describe('node_modules executable discovery', ...)` block under the existing `config` tests:

```lua
  describe('node_modules executable discovery', function()
    it('prefers a package-local executable over a hoisted executable', function()
      local workspace = tempdir()
      local package = mkdir(vim.fs.joinpath(workspace, 'packages/app'))
      touch(vim.fs.joinpath(workspace, 'pnpm-lock.yaml'))
      local hoisted = executable(mkdir(vim.fs.joinpath(workspace, 'node_modules/.bin')) .. '/astro-ls')
      local package_local = executable(mkdir(vim.fs.joinpath(package, 'node_modules/.bin')) .. '/astro-ls')

      local argv = capture_cmd(dofile('lsp/astro.lua'), { root_dir = package })

      same({ package_local, '--stdio' }, argv)
      assert.is_not.equal(hoisted, argv[1])
    end)

    it('uses an executable hoisted to the lockfile workspace', function()
      local workspace = tempdir()
      local package = mkdir(vim.fs.joinpath(workspace, 'packages/app'))
      touch(vim.fs.joinpath(workspace, 'pnpm-lock.yaml'))
      local hoisted = executable(mkdir(vim.fs.joinpath(workspace, 'node_modules/.bin')) .. '/astro-ls')

      local argv = capture_cmd(dofile('lsp/astro.lua'), { root_dir = package })

      same({ hoisted, '--stdio' }, argv)
    end)
  end)
```

- [ ] **Step 3: Add failing boundary and fallback tests**

Append these cases to the same block:

```lua
    it('does not search above a nested lockfile workspace', function()
      local outer = tempdir()
      local nested = mkdir(vim.fs.joinpath(outer, 'nested'))
      local package = mkdir(vim.fs.joinpath(nested, 'packages/app'))
      touch(vim.fs.joinpath(nested, 'package-lock.json'))
      executable(mkdir(vim.fs.joinpath(outer, 'node_modules/.bin')) .. '/astro-ls')

      local argv = capture_cmd(dofile('lsp/astro.lua'), { root_dir = package })

      same({ 'astro-ls', '--stdio' }, argv)
    end)

    it('uses the git root when no lockfile exists', function()
      local workspace = tempdir()
      local package = mkdir(vim.fs.joinpath(workspace, 'packages/app'))
      mkdir(vim.fs.joinpath(workspace, '.git'))
      local hoisted = executable(mkdir(vim.fs.joinpath(workspace, 'node_modules/.bin')) .. '/astro-ls')

      local argv = capture_cmd(dofile('lsp/astro.lua'), { root_dir = package })

      same({ hoisted, '--stdio' }, argv)
    end)

    it('uses the bare command when root_dir is nil', function()
      local argv = capture_cmd(dofile('lsp/astro.lua'), {})

      same({ 'astro-ls', '--stdio' }, argv)
    end)
```

- [ ] **Step 4: Add failing tests for command variants and Glint policy**

Append representative non-stdio and policy cases:

```lua
    it('preserves each server command argument vector', function()
      local workspace = tempdir()
      local package = mkdir(vim.fs.joinpath(workspace, 'packages/app'))
      touch(vim.fs.joinpath(workspace, 'yarn.lock'))
      local biome = executable(mkdir(vim.fs.joinpath(workspace, 'node_modules/.bin')) .. '/biome')
      local oxlint = executable(vim.fs.joinpath(workspace, 'node_modules/.bin/oxlint'))

      same({ biome, 'lsp-proxy' }, capture_cmd(dofile('lsp/biome.lua'), { root_dir = package }))
      same({ oxlint, '--lsp' }, capture_cmd(dofile('lsp/oxlint.lua'), { root_dir = package }))
    end)

    it('honors Glint useGlobal', function()
      local workspace = tempdir()
      local package = mkdir(vim.fs.joinpath(workspace, 'packages/app'))
      touch(vim.fs.joinpath(workspace, 'bun.lock'))
      executable(mkdir(vim.fs.joinpath(workspace, 'node_modules/.bin')) .. '/glint-language-server')
      local config = dofile('lsp/glint.lua')

      local argv = capture_cmd(config, {
        root_dir = package,
        init_options = { glint = { useGlobal = true } },
      })

      same({ 'glint-language-server' }, argv)
    end)
```

- [ ] **Step 5: Run the focused tests and verify the new behavior fails**

Run: `vusted ./test/lspconfig_spec.lua`

Expected: Existing tests pass, while at least the hoisted Astro, Biome, and Oxlint assertions fail because each config currently checks only `<root_dir>/node_modules/.bin`.

- [ ] **Step 6: Commit the failing specification**

```bash
git add test/lspconfig_spec.lua
git commit -m "test: specify monorepo executable discovery"
```

---

### Task 2: Implement Resolution for General Language Servers

**Files:**
- Modify: `lsp/astro.lua:79-91`
- Modify: `lsp/cssls.lua:22-33`
- Modify: `lsp/html.lua:24-35`
- Modify: `lsp/jsonls.lua:23-34`
- Modify: `lsp/rome.lua:12-23`
- Modify: `lsp/tailwindcss.lua:12-23`
- Modify: `lsp/ts_ls.lua:76-88`
- Modify: `lsp/yamlls.lua:61-72`
- Test: `test/lspconfig_spec.lua`

**Interfaces:**
- Consumes: `get_cmd(cmd: string, root_dir: string|nil)` inputs from each config's existing `cmd` function.
- Produces: Private `get_cmd` in each listed config, returning `string`; command functions pass that result into their unchanged RPC argv.

- [ ] **Step 1: Add the private bounded resolver to `lsp/astro.lua`**

Insert this function after existing local requires and before the returned config:

```lua
local function get_cmd(cmd, root_dir)
  if not root_dir then
    return cmd
  end

  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local workspace_root = vim.fs.root(root_dir, lockfiles) or vim.fs.root(root_dir, '.git') or root_dir
  local dir = root_dir
  while dir do
    local local_cmd = vim.fs.joinpath(dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      return local_cmd
    end
    if dir == workspace_root then
      break
    end
    dir = vim.fs.dirname(dir)
  end
  return cmd
end
```

Replace the local-only lookup in `cmd` with:

```lua
  cmd = function(dispatchers, config)
    local cmd = get_cmd('astro-ls', (config or {}).root_dir)
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
```

- [ ] **Step 2: Run the focused tests to verify the core resolver passes**

Run: `vusted ./test/lspconfig_spec.lua`

Expected: Astro precedence, hoisted lookup, nested lockfile boundary, Git fallback, and nil-root tests pass. Biome and Oxlint hoisted-lookup tests still fail.

- [ ] **Step 3: Apply the identical private resolver to the other general configs**

Copy the complete `get_cmd` function from Step 1 into each listed file immediately before its returned config. Replace only each current local executable block, retaining these exact argument vectors:

```lua
-- lsp/cssls.lua
local cmd = get_cmd('vscode-css-language-server', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)

-- lsp/html.lua
local cmd = get_cmd('vscode-html-language-server', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)

-- lsp/jsonls.lua
local cmd = get_cmd('vscode-json-language-server', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)

-- lsp/rome.lua
local cmd = get_cmd('rome', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)

-- lsp/tailwindcss.lua
local cmd = get_cmd('tailwindcss-language-server', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)

-- lsp/ts_ls.lua
local cmd = get_cmd('typescript-language-server', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)

-- lsp/yamlls.lua
local cmd = get_cmd('yaml-language-server', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
```

- [ ] **Step 4: Format and run focused tests**

Run: `stylua lsp/astro.lua lsp/cssls.lua lsp/html.lua lsp/jsonls.lua lsp/rome.lua lsp/tailwindcss.lua lsp/ts_ls.lua lsp/yamlls.lua test/lspconfig_spec.lua`

Run: `vusted ./test/lspconfig_spec.lua`

Expected: Astro cases pass; Biome and Oxlint hoisted-lookup assertions remain the only expected new failures.

- [ ] **Step 5: Commit the general-server implementation**

```bash
git add lsp/astro.lua lsp/cssls.lua lsp/html.lua lsp/jsonls.lua lsp/rome.lua lsp/tailwindcss.lua lsp/ts_ls.lua lsp/yamlls.lua test/lspconfig_spec.lua
git commit -m "feat: find hoisted language server executables"
```

---

### Task 3: Implement Resolution for Toolchain Servers

**Files:**
- Modify: `lsp/biome.lua:14-27`
- Modify: `lsp/oxfmt.lua:17-29`
- Modify: `lsp/oxlint.lua:22-45,94-100`
- Modify: `lsp/tsgo.lua:63-73`
- Test: `test/lspconfig_spec.lua`

**Interfaces:**
- Consumes: The same private `get_cmd(cmd: string, root_dir: string|nil): string` contract from Task 2, duplicated locally as required by config self-containment.
- Produces: Hoisted executable selection for Biome, Oxfmt, Oxlint, Tsgo, and Oxlint's optional `tsgolint` companion.

- [ ] **Step 1: Add the resolver and update Biome, Oxfmt, and Tsgo**

Add this private function before the returned config in each listed file:

```lua
local function get_cmd(cmd, root_dir)
  if not root_dir then
    return cmd
  end

  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local workspace_root = vim.fs.root(root_dir, lockfiles) or vim.fs.root(root_dir, '.git') or root_dir
  local dir = root_dir
  while dir do
    local local_cmd = vim.fs.joinpath(dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      return local_cmd
    end
    if dir == workspace_root then
      break
    end
    dir = vim.fs.dirname(dir)
  end
  return cmd
end
```

Then use these exact command bodies:

```lua
-- lsp/biome.lua
local cmd = get_cmd('biome', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)

-- lsp/oxfmt.lua
local cmd = get_cmd('oxfmt', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)

-- lsp/tsgo.lua
local cmd = get_cmd('tsgo', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
```

- [ ] **Step 2: Update Oxlint and its optional companion lookup**

Add this private function before the returned config in `lsp/oxlint.lua`:

```lua
local function get_cmd(cmd, root_dir)
  if not root_dir then
    return cmd
  end

  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local workspace_root = vim.fs.root(root_dir, lockfiles) or vim.fs.root(root_dir, '.git') or root_dir
  local dir = root_dir
  while dir do
    local local_cmd = vim.fs.joinpath(dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      return local_cmd
    end
    if dir == workspace_root then
      break
    end
    dir = vim.fs.dirname(dir)
  end
  return cmd
end
```

Replace the main command lookup with:

```lua
local cmd = get_cmd('oxlint', (config or {}).root_dir)
return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
```

Replace the `tsgolint` checks in `before_init` with:

```lua
local tsgolint_cmd = get_cmd('tsgolint', (config or {}).root_dir)
local has_tsgolint = vim.fn.executable(tsgolint_cmd) == 1
```

This preserves global `$PATH` support while adding package-local and hoisted discovery for the companion executable.

- [ ] **Step 3: Format and run focused tests**

Run: `stylua lsp/biome.lua lsp/oxfmt.lua lsp/oxlint.lua lsp/tsgo.lua test/lspconfig_spec.lua`

Run: `vusted ./test/lspconfig_spec.lua`

Expected: All tests pass, including Biome and Oxlint command-vector assertions.

- [ ] **Step 4: Commit the toolchain-server implementation**

```bash
git add lsp/biome.lua lsp/oxfmt.lua lsp/oxlint.lua lsp/tsgo.lua test/lspconfig_spec.lua
git commit -m "feat: find hoisted toolchain executables"
```

---

### Task 4: Implement Resolution for Policy-Sensitive Servers

**Files:**
- Modify: `lsp/eslint.lua:60-89`
- Modify: `lsp/glint.lua:25-37`
- Test: `test/lspconfig_spec.lua`

**Interfaces:**
- Consumes: Private `get_cmd(cmd: string, root_dir: string|nil): string` contract established in Tasks 2 and 3.
- Produces: Hoisted ESLint server lookup and opt-out-aware Glint lookup with unchanged server policies.

- [ ] **Step 1: Add bounded executable discovery to ESLint**

Add this private function after the existing locals in `lsp/eslint.lua`:

```lua
local function get_cmd(cmd, root_dir)
  if not root_dir then
    return cmd
  end

  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local workspace_root = vim.fs.root(root_dir, lockfiles) or vim.fs.root(root_dir, '.git') or root_dir
  local dir = root_dir
  while dir do
    local local_cmd = vim.fs.joinpath(dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      return local_cmd
    end
    if dir == workspace_root then
      break
    end
    dir = vim.fs.dirname(dir)
  end
  return cmd
end
```

Replace only the command selection with:

```lua
  cmd = function(dispatchers, config)
    local cmd = get_cmd('vscode-eslint-language-server', (config or {}).root_dir)
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
```

Do not change `before_init`, Yarn PnP handling, `workspaceFolder`, settings, or root selection.

- [ ] **Step 2: Add opt-out-aware executable discovery to Glint**

Add this private function before the returned config in `lsp/glint.lua`:

```lua
local function get_cmd(cmd, root_dir)
  if not root_dir then
    return cmd
  end

  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local workspace_root = vim.fs.root(root_dir, lockfiles) or vim.fs.root(root_dir, '.git') or root_dir
  local dir = root_dir
  while dir do
    local local_cmd = vim.fs.joinpath(dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      return local_cmd
    end
    if dir == workspace_root then
      break
    end
    dir = vim.fs.dirname(dir)
  end
  return cmd
end
```

Replace its command function with:

```lua
  cmd = function(dispatchers, config)
    local cmd = 'glint-language-server'
    ---@diagnostic disable-next-line: undefined-field
    if not config.init_options.glint.useGlobal then
      cmd = get_cmd(cmd, (config or {}).root_dir)
    end
    return vim.lsp.rpc.start({ cmd }, dispatchers)
  end,
```

- [ ] **Step 3: Add positive Glint lookup coverage**

Alongside the existing `useGlobal` test, add:

```lua
    it('finds a hoisted Glint executable when useGlobal is false', function()
      local workspace = tempdir()
      local package = mkdir(vim.fs.joinpath(workspace, 'packages/app'))
      touch(vim.fs.joinpath(workspace, 'bun.lockb'))
      local hoisted = executable(mkdir(vim.fs.joinpath(workspace, 'node_modules/.bin')) .. '/glint-language-server')
      local config = dofile('lsp/glint.lua')

      local argv = capture_cmd(config, {
        root_dir = package,
        init_options = { glint = { useGlobal = false } },
      })

      same({ hoisted }, argv)
    end)
```

- [ ] **Step 4: Format and run focused tests**

Run: `stylua lsp/eslint.lua lsp/glint.lua test/lspconfig_spec.lua`

Run: `vusted ./test/lspconfig_spec.lua`

Expected: All tests pass, including both Glint policy branches.

- [ ] **Step 5: Commit the policy-sensitive implementation**

```bash
git add lsp/eslint.lua lsp/glint.lua test/lspconfig_spec.lua
git commit -m "feat: support hoisted eslint and glint servers"
```

---

### Task 5: Verify Every PR #4386 Config and Full Repository Checks

**Files:**
- Modify: `test/lspconfig_spec.lua`
- Verify: `lsp/astro.lua`
- Verify: `lsp/biome.lua`
- Verify: `lsp/cssls.lua`
- Verify: `lsp/eslint.lua`
- Verify: `lsp/glint.lua`
- Verify: `lsp/html.lua`
- Verify: `lsp/jsonls.lua`
- Verify: `lsp/oxfmt.lua`
- Verify: `lsp/oxlint.lua`
- Verify: `lsp/rome.lua`
- Verify: `lsp/tailwindcss.lua`
- Verify: `lsp/ts_ls.lua`
- Verify: `lsp/tsgo.lua`
- Verify: `lsp/yamlls.lua`

**Interfaces:**
- Consumes: All private resolvers implemented in Tasks 2-4.
- Produces: Table-driven regression coverage proving all 14 configs select a hoisted executable and preserve exact arguments.

- [ ] **Step 1: Add table-driven coverage for all affected configs**

Add this test to `node_modules executable discovery`:

```lua
    it('supports every config changed by PR 4386', function()
      local cases = {
        { 'astro', 'astro-ls', { '--stdio' } },
        { 'biome', 'biome', { 'lsp-proxy' } },
        { 'cssls', 'vscode-css-language-server', { '--stdio' } },
        { 'eslint', 'vscode-eslint-language-server', { '--stdio' } },
        { 'glint', 'glint-language-server', {}, { glint = { useGlobal = false } } },
        { 'html', 'vscode-html-language-server', { '--stdio' } },
        { 'jsonls', 'vscode-json-language-server', { '--stdio' } },
        { 'oxfmt', 'oxfmt', { '--lsp' } },
        { 'oxlint', 'oxlint', { '--lsp' } },
        { 'rome', 'rome', { 'lsp-proxy' } },
        { 'tailwindcss', 'tailwindcss-language-server', { '--stdio' } },
        { 'ts_ls', 'typescript-language-server', { '--stdio' } },
        { 'tsgo', 'tsgo', { '--lsp', '--stdio' } },
        { 'yamlls', 'yaml-language-server', { '--stdio' } },
      }

      for _, case in ipairs(cases) do
        local workspace = tempdir()
        local package = mkdir(vim.fs.joinpath(workspace, 'packages/app'))
        touch(vim.fs.joinpath(workspace, 'pnpm-lock.yaml'))
        local bin = mkdir(vim.fs.joinpath(workspace, 'node_modules/.bin'))
        local hoisted = executable(vim.fs.joinpath(bin, case[2]))
        local config = dofile('lsp/' .. case[1] .. '.lua')
        local argv = capture_cmd(config, { root_dir = package, init_options = case[4] })
        local expected = vim.list_extend({ hoisted }, case[3])

        same(expected, argv, case[1])
      end
    end)
```

- [ ] **Step 2: Run the focused suite**

Run: `vusted ./test/lspconfig_spec.lua`

Expected: PASS with all 14 configs selecting their fixture's workspace-hoisted executable.

- [ ] **Step 3: Run formatting and static checks**

Run: `make lint`

Expected: StyLua and EmmyLua both pass with exit code 0.

- [ ] **Step 4: Run the full test suite**

Run: `make test`

Expected: Vusted exits 0 with all tests passing.

- [ ] **Step 5: Inspect the final diff for unintended semantic-root changes**

Run: `git diff --check`

Run: `git diff --stat HEAD~4`

Run: `git diff HEAD~4 -- lsp test/lspconfig_spec.lua`

Expected: No whitespace errors; changes are limited to private executable resolvers, command selection, Oxlint companion lookup, and tests. No `root_dir`, `root_markers`, `workspace_required`, settings, filetypes, or handler behavior changed.

- [ ] **Step 6: Commit final matrix coverage if it changed after verification**

```bash
git add test/lspconfig_spec.lua
git commit -m "test: cover hoisted executables for node servers"
```
