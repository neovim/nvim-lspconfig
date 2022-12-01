local util = require 'lspconfig.util'

local workspace_markers = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
}
return {
  default_config = {
    cmd = { 'anakinls' },
    filetypes = { 'python' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
    settings = {
      anakinls = {
        pyflakes_errors = {
          -- Full list: https://github.com/PyCQA/pyflakes/blob/master/pyflakes/messages.py

          'ImportStarNotPermitted',

          'UndefinedExport',
          'UndefinedLocal',
          'UndefinedName',

          'DuplicateArgument',
          'MultiValueRepeatedKeyLiteral',
          'MultiValueRepeatedKeyVariable',

          'FutureFeatureNotDefined',
          'LateFutureImport',

          'ReturnOutsideFunction',
          'YieldOutsideFunction',
          'ContinueOutsideLoop',
          'BreakOutsideLoop',

          'TwoStarredExpressions',
          'TooManyExpressionsInStarredAssignment',

          'ForwardAnnotationSyntaxError',
          'RaiseNotImplemented',

          'StringDotFormatExtraPositionalArguments',
          'StringDotFormatExtraNamedArguments',
          'StringDotFormatMissingArgument',
          'StringDotFormatMixingAutomatic',
          'StringDotFormatInvalidFormat',

          'PercentFormatInvalidFormat',
          'PercentFormatMixedPositionalAndNamed',
          'PercentFormatUnsupportedFormat',
          'PercentFormatPositionalCountMismatch',
          'PercentFormatExtraNamedArguments',
          'PercentFormatMissingArgument',
          'PercentFormatExpectedMapping',
          'PercentFormatExpectedSequence',
          'PercentFormatStarRequiresSequence',
        },
      },
    },
  },
  docs = {
    description = [[
https://pypi.org/project/anakin-language-server/

`anakin-language-server` is yet another Jedi Python language server.

Available options:

* Initialization: https://github.com/muffinmad/anakin-language-server#initialization-option
* Configuration: https://github.com/muffinmad/anakin-language-server#configuration-options
    ]],
    workspace_markers = workspace_markers,
  },
}
