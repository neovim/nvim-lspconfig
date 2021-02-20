local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local lsp = vim.lsp

local server_name = "denols"

local function buf_cache(bufnr)
  local params = {}
  params["referrer"] = { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }
  params["uris"] = {}
  lsp.buf_request(bufnr, "deno/cache", params)
end

local function virtual_text_document_handler(uri, result)
  if not result or #result ~= 1 then return nil end

  local lines = vim.split(result[1].result, "\n")
  local bufnr = vim.uri_to_bufnr(uri)

  local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if #current_buf ~= 0 then return nil end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, nil, lines)
  vim.api.nvim_buf_set_option(bufnr, "readonly", true)
  vim.api.nvim_buf_set_option(bufnr, "modified", false)
end

local function virtual_text_document(uri)
  local params = {
    textDocument = {
      uri = uri,
    },
  }
  local result = lsp.buf_request_sync(0, "deno/virtualTextDocument", params)
  virtual_text_document_handler(uri, result)
end

configs[server_name] = {
  default_config = {
    cmd = {"deno", "lsp"};
    filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"};
    root_dir = util.root_pattern("package.json", "tsconfig.json", ".git");
    init_options = {
      enable = true;
      lint = false;
      unstable = false;
    };
    handlers = {
      ["textDocument/definition"] = function(err, method, result)
        if not result or vim.tbl_isempty(result) then return nil end

        for _, res in pairs(result) do
          if string.sub(res.targetUri, 1, 7) == "deno://" then
            virtual_text_document(res.targetUri)
          end
        end

        lsp.handlers["textDocument/definition"](err, method, result)
      end;
    };
  };
  commands = {
    DenolsCache = {
      function()
        buf_cache(0)
      end;
      description = "Cache a module and all of its dependencies."
    };
  };
  docs = {
    description = [[
https://github.com/denoland/deno

Deno's built-in language server
]];
    default_config = {
      root_dir = [[root_pattern("package.json", "tsconfig.json", ".git")]];
    };
  };
}

configs.denols.buf_cache = buf_cache
configs.denols.virtual_text_document = virtual_text_document
-- vim:et ts=2 sw=2
