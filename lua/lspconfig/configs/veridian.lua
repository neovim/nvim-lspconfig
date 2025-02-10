return {
  default_config = {
    cmd = { 'veridian' },
    filetypes = { 'systemverilog', 'verilog' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/vivekmalneedi/veridian

A SystemVerilog LanguageServer.

Download the latest release for your OS from the releases page

Install with slang feature, if C++17 compiler is available:
```
cargo install --git https://github.com/vivekmalneedi/veridian.git --all-features
```

Install if C++17 compiler is not available:
```
cargo install --git https://github.com/vivekmalneedi/veridian.git
```
    ]],
  },
}
