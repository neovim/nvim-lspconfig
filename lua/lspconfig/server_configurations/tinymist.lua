return {
  default_config = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_dir = function()
      return vim.fn.getcwd()
    end,
    settings = {
      exportPdf = "never", -- doesn't export PDF by default
    },
  },
  docs = {
    description = [[
https://github.com/Myriad-Dreamin/tinymist

An integrated language service for Typst [taɪpst]. You can also call it "微霭" [wēi ǎi] in Chinese.
    ]],
  },
}
