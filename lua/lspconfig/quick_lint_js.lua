local configs = require("lspconfig/configs")
local util = require("lspconfig/util")

configs.quick_lint_js = {
  default_config = {
    cmd = {"quick-lint-js", "--lsp-server"},
    filetypes = {"javascript", "javascriptreact"},
    root_dir = function(fname)
      return util.find_node_modules_ancestor(fname) or
        util.find_git_ancestor(fname) or util.path.dirname(fname)
    end
  },
  docs = {
    description = [[
https://quick-lint-js.com/

quick-lint-js finds bugs in JavaScript programs.

[200× faster than ESLint](https://quick-lint-js.com/benchmarks/),
quick-lint-js gives you instant feedback as you code.
Find bugs in your JavaScript before your finger leaves the keyboard.
Lint any JavaScript file with no configuration.

```sh
npm install [-g] quick-lint-js
```
]],
    default_config = {
      root_dir = [[root_pattern('package.json', 'node_modules', '.git') or dirname]]
    },
  },
}
