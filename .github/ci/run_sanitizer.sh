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

SEARCH_PATTERN='(util\.path\.dirname)'

if git diff --pickaxe-all -U0 -G "${SEARCH_PATTERN}" "${REF_BRANCH}" "${PR_BRANCH}" -- '*.lua' | grep -Ev '\.lua$' | grep -E "^\+.*${SEARCH_PATTERN}" ; then
  echo
  echo 'Do not use deprecated util functions: '"${SEARCH_PATTERN}"
  exit 1
fi
