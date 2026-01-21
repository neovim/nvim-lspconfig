--- @brief
--- Utility for detecting the root directory of a TypeScript project

local M = {}

--- @class lspconfig.typescript.Project
--- @field kind '"node"' | '"deno"' | '"bun"'
--- @field root_dir string

--- @class lspconfig.typescript.Package
--- @field kind '"non-deno"' | '"deno"'
--- @field path string

--- @class lspconfig.typescript.Workspace
--- @field kind '"node"' | '"deno"' | '"bun"'
--- @field root_dir string

--- Detect the TypeScript project in the current working directory.
--- @param source (integer | string)
--- @return lspconfig.typescript.Project?
function M.detect_project(source)
  -- The search scope limit is the closer of either the current directory or the closest Git repository directly above the file.
  -- This prevents false positives if files like package-lock.json exist in the home directory.
  local cwd = vim.fn.getcwd()
  local git_root = vim.fs.root(source, '.git')
  local root = (git_root and #git_root >= #cwd) and git_root or cwd

  -- First, we look for configuration files that indicate the presence of a specific runtime under the root.

  --- @type lspconfig.typescript.Package[]
  local packages = {}

  local non_deno_package = vim.fs.root(source, { 'package.json' })
  if non_deno_package and (#non_deno_package >= #root) then
    table.insert(packages, { kind = 'non-deno', path = non_deno_package })
  end

  local deno_package = vim.fs.root(source, { 'deno.json', 'deno.jsonc' })
  if deno_package and (#deno_package >= #root) then
    table.insert(packages, { kind = 'deno', path = deno_package })
  end

  table.sort(packages, function(a, b)
    return #a.path > #b.path
  end)

  --- @type lspconfig.typescript.Package?
  local closest_package = (#packages == 1 or (#packages > 1 and #packages[1].path > #packages[2].path)) and packages[1]
    or nil

  if not closest_package then
    -- If no package is found, there is no useful information regarding the project.
    return nil
  end

  -- Second, we look for a lock file that can reliably distinguish between runtime kind.

  --- @type lspconfig.typescript.Workspace[]
  local workspaces = {}

  local node_workspace_root = vim.fs.root(source, { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml' })
  if node_workspace_root and (#root <= #node_workspace_root) and (#node_workspace_root <= #closest_package.path) then
    table.insert(workspaces, { kind = 'node', root_dir = node_workspace_root })
  end

  local deno_workspace_root = vim.fs.root(source, { 'deno.lock' })
  if deno_workspace_root and (#root <= #deno_workspace_root) and (#deno_workspace_root <= #closest_package.path) then
    table.insert(workspaces, { kind = 'deno', root_dir = deno_workspace_root })
  end

  local bun_workspace_root = vim.fs.root(source, { 'bun.lock', 'bun.lockb' })
  if bun_workspace_root and (#root <= #bun_workspace_root) and (#bun_workspace_root <= #closest_package.path) then
    table.insert(workspaces, { kind = 'bun', root_dir = bun_workspace_root })
  end

  -- If there is only one directory that is closest, this is the workspace we should find.
  -- If there are multiple workspaces pointing to the same directory, or if no workspaces are found,
  -- `detected_workspace` will be nil as there is no useful information regarding the workspace.

  table.sort(workspaces, function(a, b)
    return #a.root_dir > #b.root_dir
  end)

  --- @type lspconfig.typescript.Workspace?
  local detected_workspace = (
    #workspaces == 1 or (#workspaces > 1 and #workspaces[1].root_dir > #workspaces[2].root_dir)
  )
      and workspaces[1]
    or nil

  -- If no workspace is detected, the closest package directly above the file will be detected.
  if not detected_workspace then
    if closest_package.kind == 'deno' then
      return { kind = 'deno', root_dir = closest_package.path }
    else
      return { kind = 'node', root_dir = closest_package.path }
    end
  end

  -- If a non-Deno workspace is detected:
  -- - If the immediate parent package is non-Deno, it is considered a package within that workspace, and root_dir is set to the workspace root.
  -- - If the immediate parent package is Deno, it is considered a single Deno project located under an unrelated non-Deno workspace.
  if detected_workspace.kind == 'node' or detected_workspace.kind == 'bun' then
    if closest_package.kind == 'non-deno' then
      return { kind = detected_workspace.kind, root_dir = detected_workspace.root_dir }
    else
      return { kind = 'deno', root_dir = closest_package.path }
    end
  end

  -- If a Deno workspace is detected:
  --   A package.json file within a Deno workspace cannot be used as a determining factor,
  --   as it might be leveraging Deno's first-class package.json support.
  --   Therefore, it is immediately considered a package within a Deno workspace.
  -- See: https://docs.deno.com/runtime/fundamentals/node/#first-class-package.json-support
  if detected_workspace.kind == 'deno' then
    return { kind = 'deno', root_dir = detected_workspace.root_dir }
  end

  return nil
end

return M
