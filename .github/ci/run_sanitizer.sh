#!/usr/bin/env bash
set -e

REF_BRANCH="$1"
PR_BRANCH="$2"

# checks for added lines that contain search pattern and prints them
SEARCH_PATTERN='(path\.dirname|fn\.cwd)'

if git diff --pickaxe-all -U0 -G "${SEARCH_PATTERN}" "${REF_BRANCH}" "${PR_BRANCH}" -- '*.lua' | grep -Ev '(configs|utils)\.lua$' | grep -E "^\+.*${SEARCH_PATTERN}" ; then
  echo
  echo 'String "dirname" found. There is a high risk that this might contradict the directive:'
  echo '"Do not use vim.fn.cwd or util.path.dirname in root_dir".'
  echo "see: https://github.com/neovim/nvim-lspconfig/blob/master/CONTRIBUTING.md#adding-a-server-to-lspconfig."
  exit 1
fi

SEARCH_PATTERN='(util\.path\.dirname|util\.path\.sanitize|util\.path\.exists|util\.path\.is_file|util\.path\.is_dir|util\.path\.join|util\.path\.iterate_parents|util\.path\.traverse_parents|util\.find_mercurial_ancestor|util\.find_node_modules_ancestor|util\.find_package_json_ancestor|util\.find_git_ancestor|util\.root_pattern)'

if git diff --pickaxe-all -U0 -G "${SEARCH_PATTERN}" "${REF_BRANCH}" "${PR_BRANCH}" -- '*.lua' | grep -Ev '\.lua$' | grep -E "^\+.*${SEARCH_PATTERN}" ; then
  echo
  echo 'Do not use deprecated util functions: '"${SEARCH_PATTERN}"
  exit 1
fi

SEARCH_PATTERN='(vim\.uv)'

if git diff --pickaxe-all -U0 -G "${SEARCH_PATTERN}" "${REF_BRANCH}" "${PR_BRANCH}" -- '*.lua' | grep -Ev '\.lua$' | grep -E "^\+.*${SEARCH_PATTERN}" ; then
  echo
  echo 'Do not use modules that are too new: '"${SEARCH_PATTERN}"
  echo 'Consult README to check the minimum supported neovim version.'
  exit 1
fi
