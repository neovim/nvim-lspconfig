# Monorepo Node Modules Executable Discovery

## Goal

Allow the language-server configs changed by PR #4386 to use executables hoisted to a JavaScript monorepo's top-level `node_modules/.bin`, while preserving each server's existing workspace and configuration-root behavior.

## Scope

Update the PR #4386 configs that currently derive a local executable only from `config.root_dir`:

- `astro`
- `biome`
- `cssls`
- `eslint`
- `glint`
- `html`
- `jsonls`
- `oxfmt`
- `oxlint`
- `rome`
- `tailwindcss`
- `ts_ls`
- `tsgo`
- `yamlls`

Do not change `root_dir`, `root_markers`, `workspace_required`, filetypes, server arguments, or server-specific command policies. In particular, Glint's `init_options.glint.useGlobal` behavior remains authoritative.

## Design

Each config remains self-contained, following the maintainer direction in PR #4386. Its command resolver starts at `config.root_dir` and checks each ancestor's `node_modules/.bin/<server-command>` until reaching the detected JavaScript workspace boundary.

The workspace boundary uses the same marker priorities as `ts_ls`:

1. The nearest ancestor containing one of `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb`, or `bun.lock`.
2. The nearest Git root when no package-manager lockfile is found first.
3. `config.root_dir` when neither marker exists above it.

Lookup order is nearest-first. A package-local executable therefore overrides a hoisted executable. Traversal includes the boundary directory but never searches above it. If no executable is found, the resolver retains the existing bare command so normal `$PATH` resolution still applies.

This changes only process executable selection. It intentionally does not make every language server use one process for the entire monorepo because several configs use package-level roots to select tool configuration, settings, or versions.

## Error Handling

- A missing or nil `config.root_dir` immediately uses the existing bare command.
- Missing `node_modules` directories and non-executable candidates are skipped.
- Filesystem marker lookup failure falls back to checking only `config.root_dir`.
- Existing RPC startup behavior reports command startup failures; no new notification path is added.

## Testing

Add focused automated coverage using temporary monorepo fixtures and executable files:

- A package-local executable wins over a workspace-hoisted executable.
- A workspace-hoisted executable is selected when the package has none.
- Search includes the lockfile or Git boundary and does not escape above it.
- A nested lockfile limits lookup to the nested workspace.
- No local executable preserves the bare global command.
- A nil root preserves the bare global command.
- Existing server arguments are unchanged.
- Glint with `useGlobal = true` does not perform local lookup.

Because configs must remain self-contained, tests should exercise representative command functions and the common lookup behavior rather than introducing a production helper in frozen legacy code.

## Compatibility

The change is backward compatible for simple repositories: the first candidate remains `<root_dir>/node_modules/.bin/<command>`, exactly as in PR #4386. Monorepos gain fallback to an executable in an ancestor workspace. Users can still override `cmd` through `vim.lsp.config`.
