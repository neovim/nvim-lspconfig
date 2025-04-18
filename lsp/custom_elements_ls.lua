---@brief
---
--- https://github.com/Matsuuu/custom-elements-language-server
---
--- `custom-elements-languageserver` depends on `typescript`. Both packages can be installed via `npm`:
--- ```sh
--- npm install -g typescript custom-elements-languageserver
--- ```
--- To configure typescript language server, add a
--- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) or
--- [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to the root of your
--- project.
--- Here's an example that disables type checking in JavaScript files.
--- ```json
--- {
---   "compilerOptions": {
---     "module": "commonjs",
---     "target": "es6",
---     "checkJs": false
---   },
---   "exclude": [
---     "node_modules"
---   ]
--- }
--- ```
return {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'custom-elements-languageserver', '--stdio' },
  root_dir = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
}
