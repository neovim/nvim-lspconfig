---@brief
---
--- https://github.com/huacnlee/autocorrect
---
--- AutoCorrect checks and fixes spacing, punctuation, and spelling between CJK (Chinese, Japanese, Korean) and English
--- text. It checks the strings and comments of source files, and the full text of Markdown and plain text files.
---
--- `autocorrect` can be installed with Homebrew:
--- ```sh
--- brew install autocorrect
--- ```
---
--- Or downloaded from the [GitHub releases page](https://github.com/huacnlee/autocorrect/releases).

---@type vim.lsp.Config
return {
  cmd = { 'autocorrect', 'server' },
  -- autocorrect reads .autocorrectrc and .autocorrectignore only from the root directory.
  root_markers = { '.autocorrectrc', '.autocorrectignore', '.git' },
}
