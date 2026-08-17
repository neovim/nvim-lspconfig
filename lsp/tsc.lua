---@brief
---
--- https://github.com/microsoft/typescript
---
--- TypeScript is a language for application-scale JavaScript.
--- TypeScript adds optional types to JavaScript that support tools for large-scale JavaScript applications for any browser, for any host, on any OS.
--- TypeScript compiles to readable, standards-based JavaScript.
---
--- `tsc` can be installed via npm `npm install typescript`.
---
--- The language server (`--lsp`) is only available in the native compiler, TypeScript 7.0
--- and newer. An older binary in `node_modules/.bin` is skipped in favour of one on `$PATH`
--- that does support it; if no candidate qualifies, the server does not attach.
---
--- ### Monorepo support
---
--- `tsc` supports monorepos by default. It will automatically find the `tsconfig.json` or `jsconfig.json` corresponding to the package you are working on.
--- This works without the need of spawning multiple instances of `tsc`, saving memory.
---
--- It is recommended to use the same version of TypeScript in all packages, and therefore have it available in your workspace root. The location of the TypeScript binary will be determined automatically, but only once.
---
--- Some care must be taken here to correctly infer whether a file is part of a Deno program, or a TS program that
--- expects to run in Node or Web Browsers. This supports having a Deno module using the denols LSP as a part of a
--- mostly-not-Deno monorepo. We do this by finding the nearest package manager lock file, and the nearest deno.json
--- or deno.jsonc.
---
--- Example:
---
--- ```
--- project-root
--- +-- node_modules/...
--- +-- package-lock.json
--- +-- package.json
--- +-- packages
---     +-- deno-module
---     |   +-- deno.json
---     |   +-- package.json <-- It's normal for Deno projects to have package.json files!
---     |   +-- src
---     |       +-- index.ts <-- this is a Deno file
---     +-- node-module
---         +-- package.json
---         +-- src
---             +-- index.ts <-- a non-Deno file (ie, should use ts_ls or tsc)
--- ```
---
--- From the file being edited, we walk up to find the nearest package manager lockfile. This is PROJECT ROOT.
--- From the file being edited, find the nearest deno.json or deno.jsonc. This is DENO ROOT.
--- From the file being edited, find the nearest deno.lock. This is DENO LOCK ROOT
--- If DENO LOCK ROOT is found, and PROJECT ROOT is missing or shorter, then this is a deno file, and we abort.
--- If DENO ROOT is found, and it's longer than or equal to PROJECT ROOT, then this is a Deno file, and we abort.
--- Otherwise, attach at PROJECT ROOT, or the cwd if not found.

local bin_cache = {} ---@type table<string, string>

--- Checks if the given tsc/tsgo cmd supports the "--lsp" arg.
---@param bin string
---@return boolean
local function supports_lsp(bin)
  if vim.fn.executable(bin) ~= 1 then
    return false
  end

  local out = vim.system({ bin, '--version' }, { text = true }):wait()
  local version = vim.version.parse(out.stdout or '')

  return out.code == 0 and version ~= nil and version.major >= 7
end

---@type vim.lsp.Config
return {
  settings = {
    ['js/ts'] = {
      inlayHints = {
        parameterNames = {
          enabled = 'literals',
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
      implementationsCodeLens = {
        enabled = true,
        showOnInterfaceMethods = true,
        showOnAllClassMethods = true,
      },
    },
  },
  cmd = function(dispatchers, config)
    local cmd = bin_cache[(config or {}).root_dir] or 'tsc'
    return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })

    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
      -- deno lock is closer than package manager lock, abort
      return
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
      -- deno config is closer than or equal to package manager lock, abort
      return
    end
    -- project is standard TS, not deno
    -- We fallback to the current working directory if no project root is found
    local root = project_root or vim.fn.getcwd()

    if bin_cache[root] then
      return on_dir(root)
    end

    local bins = {}

    for _, bin in ipairs({ 'tsc', 'tsgo' }) do
      bins[#bins + 1] = vim.fs.joinpath(root, 'node_modules/.bin', bin)
      bins[#bins + 1] = bin
    end

    for _, bin in ipairs(bins) do
      if supports_lsp(bin) then
        bin_cache[root] = bin
        return on_dir(root)
      end
    end

    vim.notify('tsc: no binary supporting `--lsp` found (requires TypeScript 7.0+)', vim.log.levels.WARN)
  end,
}
