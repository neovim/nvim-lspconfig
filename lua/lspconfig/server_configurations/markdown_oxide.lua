return {
  default_config = {
    root_dir = function(fname, _)
      return require('lspconfig').util.root_pattern('.git', '.obsidian', '.moxide.toml')(fname)
    end,
    filetypes = { 'markdown' },
    single_file_support = true,
    cmd = { 'markdown-oxide' },
  },
  docs = {
    description = [[
https://github.com/Feel-ix-343/markdown-oxide

Let's record your consciousness! Bring your own text editor!
Implemented as a language server compatible with any text
editor, Markdown-Oxide is attempting to be the best PKM
system for software enthusiasts.

Check the readme to see how to properly setup nvim-cmp.
    ]],
  },
  commands = {
    Today = {
      function()
        vim.lsp.buf.execute_command({command="jump", arguments={"today"}})
      end,
      description = "Open today's daily note"
    },
    Tomorrow = {
      function()
        vim.lsp.buf.execute_command({command="jump", arguments={"tomorrow"}})
      end,
      description = "Open tomorrow's daily note"
    },
    Yesterday = {
      function()
        vim.lsp.buf.execute_command({command="jump", arguments={"yesterday"}})
      end,
      description = "Open yesterday's daily note"
    },
  }
}
}
