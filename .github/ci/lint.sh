#!/usr/bin/env bash

# USAGE: To run locally:
#   bash .github/ci/lint.sh origin/master HEAD

set -e

REF_BRANCH="$1"
PR_BRANCH="$2"

# Enforce buffer-local commands.
_check_cmd_buflocal() {
  if git grep -P 'nvim_create_user_command' -- 'lsp/*.lua' ; then
    echo
    echo 'Define commands with nvim_buf_create_user_command (buffer-local), not nvim_create_user_command'
    exit 1
  fi
}

# Check that "@brief" docstring is the first line of each "lsp/*.lua" config.
_check_brief_placement() {
  if find ./lsp -type f -name "*.lua" -exec awk 'NR==1 && !/brief/{print FILENAME}' {} \; | grep --color=never '.' ; then
    echo
    echo '`@brief` docstring must be at the top of the config source file'
    exit 1
  fi
}

# Enforce "Lsp" prefix on all user commands.
_check_lsp_cmd_prefix() {
  local exclude='tinymist'
  if git grep -P 'nvim_buf_create_user_command' -- 'lsp/*.lua' | grep -v "$exclude" | grep --color -v Lsp ; then
    echo
    echo 'Command names must start with "Lsp" prefix'
    exit 1
  fi
}

# Enforce client:exec_cmd().
_check_exec_cmd() {
  if git grep -P 'workspace.executeCommand' -- 'lsp/*.lua' ; then
    echo
    echo 'Use client:exec_cmd() instead of calling request("workspace/executeCommand") directly. Example: lsp/pyright.lua'
    exit 1
  fi
}

# Disallow util functions in Nvim 0.11+ (lsp/) configs.
_check_deprecated_in_nvim_0_11() {
  if git grep -P 'is_descendant' -- 'lsp/*.lua' ; then
    echo
    echo 'Use vim.fs.relpath() instead of util.path.is_descendant()'
    exit 1
  fi
  if git grep -P 'search_ancestors' -- 'lsp/*.lua' ; then
    echo
    echo 'Use vim.iter(vim.fs.parents(fname)):find(…) instead of util.path.search_ancestors(fname,…)'
    exit 1
  fi
}

_check_deprecated_utils() {
  # checks for added lines that contain search pattern and prints them
  SEARCH_PATTERN='(path\.dirname|fn\.cwd)'

  if git diff --pickaxe-all -U0 -G "${SEARCH_PATTERN}" "${REF_BRANCH}" "${PR_BRANCH}" -- '*.lua' | grep -Ev '(configs|utils)\.lua$' | grep -E "^\+.*${SEARCH_PATTERN}" ; then
    echo
    echo 'String "dirname" found. There is a high risk that this might contradict the directive:'
    echo '"Do not use vim.fn.cwd or util.path.dirname in root_dir".'
    echo "see: https://github.com/neovim/nvim-lspconfig/blob/master/CONTRIBUTING.md#adding-a-server-to-lspconfig."
    exit 1
  fi

  SEARCH_PATTERN='(util\.path\.dirname|util\.path\.sanitize|util\.path\.exists|util\.path\.is_file|util\.path\.is_dir|util\.path\.join|util\.path\.iterate_parents|util\.find_mercurial_ancestor|util\.find_node_modules_ancestor|util\.find_package_json_ancestor|util\.find_git_ancestor|util\.get_lsp_clients|util\.get_active_client_by_name)'

  if git diff --pickaxe-all -U0 -G "${SEARCH_PATTERN}" "${REF_BRANCH}" "${PR_BRANCH}" -- '*.lua' | grep -Ev '\.lua$' | grep -E "^\+.*${SEARCH_PATTERN}" ; then
    echo
    echo 'Do not use deprecated util functions: '"${SEARCH_PATTERN}"
    exit 1
  fi
}

_check_cmd_buflocal
_check_brief_placement
_check_lsp_cmd_prefix
_check_exec_cmd
_check_deprecated_in_nvim_0_11
_check_deprecated_utils
