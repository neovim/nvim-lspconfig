---@brief
---
--- https://github.com/snyk/snyk-ls
---
--- **[Snyk](https://snyk.io)** is a developer security platform that helps you find and fix
--- vulnerabilities in your code, open source dependencies, containers, and infrastructure as code.
---
--- The Snyk Language Server provides real-time security scanning for:
--- - **Snyk Open Source**: Find and fix vulnerabilities in open source dependencies
--- - **Snyk Code**: Find and fix security vulnerabilities in your code
--- - **Snyk Infrastructure as Code**: Find and fix security issues in Kubernetes, Terraform, and other IaC files
---
--- ## Authentication
---
--- **Note**: Currently, only token-based authentication is supported in Neovim.
---
--- 1. Get your API token from https://app.snyk.io/account
--- 2. Set the `SNYK_TOKEN` environment variable:
---    ```sh
---    export SNYK_TOKEN="your-token-here"
---    ```
---
--- ## Trusted Folders
---
--- Snyk requires you to trust directories before scanning them. To avoid being prompted every time:
---
--- ```lua
--- vim.lsp.config('snyk_ls', {
---   init_options = {
---     trustedFolders = {
---       '/Users/yourname/projects',  -- Trust your projects directory
---       '/path/to/another/trusted/dir',
---     },
---   },
--- })
--- ```
---
--- **Important**: Trust the top-level directory where you store your repositories, not individual repos.
--- For example, if you work on `/Users/yourname/projects/my-app`, trust `/Users/yourname/projects`.
--- Only trust directories containing code you trust to scan.
---
--- ## Configuration
---
--- Full configuration options available at https://github.com/snyk/snyk-ls#configuration-1
---
--- ### Advanced Configuration
---
--- For **non-default multi-tenant or single-tenant setups**, you may need to specify:
---
--- - `endpoint`: Custom Snyk API endpoint (e.g., `https://api.eu.snyk.io` for EU, or your single-tenant URL)
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'snyk', 'language-server', '-l', 'info' },
  root_markers = { '.git', '.snyk' },
  filetypes = {
    'apex',
    'apexcode',
    'c',
    'cpp',
    'cs',
    'dart',
    'dockerfile',
    'elixir',
    'eelixir',
    'go',
    'gomod',
    'groovy',
    'helm',
    'java',
    'javascript',
    'json',
    'kotlin',
    'objc',
    'objcpp',
    'php',
    'python',
    'requirements',
    'ruby',
    'rust',
    'scala',
    'swift',
    'terraform',
    'terraform-vars',
    'typescript',
    'yaml',
  },
  settings = {},
  init_options = {
    activateSnykOpenSource = 'true', -- Scan open source dependencies
    activateSnykCode = 'false', -- Scan your code for vulnerabilities
    activateSnykIac = 'true', -- Scan infrastructure as code
    integrationName = 'Neovim',
    integrationVersion = tostring(vim.version()),
    token = os.getenv('SNYK_TOKEN') or vim.NIL,
    trustedFolders = {}, -- Add your trusted directories here to avoid being prompted every time
  },
}
