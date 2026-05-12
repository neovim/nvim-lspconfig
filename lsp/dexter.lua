---@brief
---
--- https://github.com/remoteoss/dexter
---
--- `dexter` is a fast, full-featured Elixir LSP optimized for large codebases.
---
--- `dexter` can be installed via Homebrew, mise, or asdf:
---
--- Via Homebrew:
--- ```sh
--- brew install remoteoss/tap/dexter
--- ```
---
--- Via mise:
--- ```sh
--- mise plugin add dexter https://github.com/remoteoss/dexter.git
--- mise install dexter
--- ```
---
--- Via asdf:
--- ```sh
--- asdf plugin add dexter https://github.com/remoteoss/dexter.git
--- asdf install dexter latest
--- ```
---
--- `dexter` works without compilation by parsing source files directly, providing:
--- - Fast indexing (cold index in ~11s on 57k-file codebases)
--- - Go-to-definition with alias and delegate resolution
--- - Find references across the codebase
--- - Hover documentation and autocompletion
--- - Rename functionality with automatic file renaming
--- - Format on save via persistent Elixir process
---
--- Configuration example:
--- ```lua
--- vim.lsp.config('dexter', {
---   init_options = {
---     followDelegates = true,  -- jump through defdelegate to the target function
---     -- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
---     -- debug = false,        -- verbose logging to stderr (view with :LspLog)
---   },
--- })
--- vim.lsp.enable('dexter')
--- ```
---

---@type vim.lsp.Config
return {
  cmd = { 'dexter', 'lsp' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
  root_markers = { '.dexter/dexter.db', '.dexter.db', '.git', 'mix.exs' },
  init_options = {
    followDelegates = true,
  },
}
