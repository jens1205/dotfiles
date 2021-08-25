-- LSP settings
local nvim_lsp = require('lspconfig')
local on_attach = function(_client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  require'mappings'.lsp(bufnr)

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
}
----------------------
-- Language Server  --
----------------------

-- rust
nvim_lsp.rust_analyzer.setup {
	on_attach = on_attach,
}


-- gopls
local go_on_attach = function(default_attach_func)
    return function(_client, bufnr)
        default_attach_func()
        vim.lsp.codelens.refresh()
    end
end

nvim_lsp.gopls.setup {
	on_attach = go_on_attach(on_attach),
	capabilities = capabilities,
	--cmd = {"gopls", "serve" },
    init_options = {
         codelenses = {
             test = true,
        },
    },
	settings = {
	    gopls = {
            usePlaceholders = true,
            allowImplicitNetworkAccess = true,
            allowModfileModifications = true,
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            codelenses = {
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
                generate = true,
                test = true,
            },
	    },
    },
}

-- taken from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-config
function goimports(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if result == nil or result[1] == nil or not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]
    -- print(vim.inspect(action))

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        if action.command.arguments[1].Fix == "fill_struct" then return end
        vim.lsp.buf.execute_command(action.command)
      end
    else
      if action.arguments[1].Fix == "fill_struct" then return end
      vim.lsp.buf.execute_command(action)
    end
end

vim.api.nvim_command('autocmd BufWritePre *.go lua goimports(1000)')
vim.api.nvim_command('autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)')
vim.api.nvim_command('autocmd BufWritePre go.mod lua vim.lsp.buf.formatting_sync(nil, 1000)')
vim.api.nvim_command('autocmd BufWritePost *.go lua vim.lsp.codelens.refresh()')
-- gopls end

-- local sumneko_root_path = vim.fn.getenv("HOME").."/.local/bin/sumneko_lua" -- Change to your sumneko root installation
local sumneko_root_path = vim.fn.getenv("HOME").."/bin/lua-language-server" -- Change to your sumneko root installation
-- local sumneko_binary_path = vim.fn.getenv("HOME").."/bin/lua-language-server" -- Change to your OS specific output folder
local sumneko_binary = "/bin/lua-language-server" -- Change to your OS specific output folder
nvim_lsp.sumneko_lua.setup {
  -- cmd = {sumneko_root_path .. sumneko_binary_path, "-E", sumneko_root_path.."/main.lua" };
  cmd = {sumneko_root_path .. sumneko_binary, "-E", sumneko_root_path.."/main.lua" };
  on_attach = on_attach,
  settings = {
      Lua = {
          runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
          },
          diagnostics = {
              globals = {'vim'},
          },
          workspace = {
              library = {
                  [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                  [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              },
          },
      },
  },
}

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

-- put LSP diagnostics into location list - START
-- WARnING! Does open a non closable window on the bottom with neovim v0.6
-- I don't need it as I am using trouble...

--vim.api.nvim_exec([[

--augroup Custom_LSP
--    autocmd!
--    autocmd BufWrite,BufEnter,InsertLeave * :lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
--augroup END
--]], false)
-- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()

-- put LSP diagnostics into location list - END

-- LSP End

vim.fn.sign_define("LspDiagnosticsSignError",
    {text = ""})
vim.fn.sign_define("LspDiagnosticsSignWarning",
    {text = ""})
vim.fn.sign_define("LspDiagnosticsSignInformation",
    {text = ""})
vim.fn.sign_define("LspDiagnosticsSignHint",
    {text = ""})