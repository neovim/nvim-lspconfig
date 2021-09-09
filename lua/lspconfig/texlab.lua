local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local lsp = vim.lsp

local texlab_build_status = vim.tbl_add_reverse_lookup {
  Success = 0,
  Error = 1,
  Failure = 2,
  Cancelled = 3,
}

local texlab_forward_status = vim.tbl_add_reverse_lookup {
  Success = 0,
  Error = 1,
  Failure = 2,
  Unconfigured = 3,
}

-- add compatibility shim for breaking signature change
local function mk_handler(fn)
   return function(...)
     local config_or_client_id = select(4, ...)
     local is_new = type(config_or_client_id) ~= 'number'
     if is_new then
       fn(...)
     else
       local err = select(1, ...)
       local method = select(2, ...)
       local result = select(3, ...)
       local client_id = select(4, ...)
       local bufnr = select(5, ...)
       local config = select(6, ...)
       fn(err, result, { method = method, client_id = client_id, bufnr = bufnr }, config)
     end
   end
 end


 local function request(bufnr, method, params, handler)
   return lsp.buf_request(bufnr, method, params, mk_handler(handler))
 end

local function buf_build(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }
  request(bufnr, 'textDocument/build', params, function(err, result, _)
    if err then
      error(tostring(err))
    end
    print('Build ' .. texlab_build_status[result.status])
  end)
end

local function buf_search(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    position = { line = vim.fn.line '.' - 1, character = vim.fn.col '.' },
  }
  request(bufnr, 'textDocument/forwardSearch', params, function(err, result, _)
    if err then
      error(tostring(err))
    end
    print('Search ' .. texlab_forward_status[result.status])
  end)
end

-- bufnr isn't actually required here, but we need a valid buffer in order to
-- be able to find the client for buf_request.
-- TODO find a client by looking through buffers for a valid client?
-- local function build_cancel_all(bufnr)
--   bufnr = util.validate_bufnr(bufnr)
--   local params = { token = "texlab-build-*" }
--   lsp.buf_request(bufnr, 'window/progress/cancel', params, function(err, method, result, client_id)
--     if err then error(tostring(err)) end
--     print("Cancel result", vim.inspect(result))
--   end)
-- end

configs.texlab = {
  default_config = {
    cmd = { 'texlab' },
    filetypes = { 'tex', 'bib' },
    root_dir = util.path.dirname,
    settings = {
      texlab = {
        rootDirectory = nil,
        build = {
          executable = 'latexmk',
          args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
          onSave = false,
          forwardSearchAfter = false,
        },
        auxDirectory = '.',
        forwardSearch = {
          executable = nil,
          args = {},
        },
        chktex = {
          onOpenAndSave = false,
          onEdit = false,
        },
        diagnosticsDelay = 300,
        latexFormatter = 'latexindent',
        latexindent = {
          ['local'] = nil, -- local is a reserved keyword
          modifyLineBreaks = false,
        },
        bibtexFormatter = 'texlab',
        formatterLineLength = 80,
      },
    },
  },
  commands = {
    TexlabBuild = {
      function()
        buf_build(0)
      end,
      description = 'Build the current buffer',
    },
    TexlabForward = {
      function()
        buf_search(0)
      end,
      description = 'Forward search from current position',
    },
  },
  docs = {
    description = [[
https://github.com/latex-lsp/texlab

A completion engine built from scratch for (La)TeX.

See https://github.com/latex-lsp/texlab/blob/master/docs/options.md for configuration options.
]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}

configs.texlab.buf_build = buf_build
configs.texlab.buf_search = buf_search
