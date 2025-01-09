-- LSP settings
local nvim_lsp = require("lspconfig")
local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	require("mappings").lsp(bufnr)

	if client and client.supports_method("textDocument/formatting") then
		local format_enabled = true
		vim.api.nvim_buf_create_user_command(0, "FormatDisable", function()
			format_enabled = false
		end, {})
		vim.api.nvim_buf_create_user_command(0, "FormatEnable", function()
			format_enabled = true
		end, {})
		local lsp_augroup = "custom_lsp_augroup" .. bufnr
		vim.api.nvim_create_augroup(lsp_augroup, { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = lsp_augroup,
			buffer = bufnr,
			callback = function()
				print("formatting", format_enabled)
				if format_enabled then
					vim.lsp.buf.format({ timeout_ms = 3000 })
				end
			end,
		})
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}
----------------------
-- Language Server  --
----------------------

-- html
require("lspconfig").html.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- javascript & typescript
require("lspconfig").ts_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- require("lspconfig").jsonls.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })

-- terraform
require("lspconfig").terraformls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- rust
-- nvim_lsp.rust_analyzer.setup({
-- 	on_attach = on_attach,
-- })
-- nvim_lsp.rust_analyzer.setup({
-- 	on_attach = on_attach,
-- 	settings = {
-- 		["rust-analyzer"] = {
-- 			assist = {
-- 				importMergeBehavior = "last",
-- 				importPrefix = "by_self",
-- 			},
-- 			diagnostics = {
-- 				disabled = { "unresolved-import" },
-- 			},
-- 			cargo = {
-- 				loadOutDirsFromCheck = true,
-- 			},
-- 			procMacro = {
-- 				enable = true,
-- 			},
-- 			checkOnSave = {
-- 				command = "clippy",
-- 			},
-- 		},
-- 	},
-- })

-- gopls
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
-- for Go files we are using functionality provided by https://github.com/ray-x/go.nvim
-- instead of automatically directly using the lsp itself. go.nvim internally is first calling the organizeImports
-- codeAction, and is doing the formating after this (both also via the gopls lsp)
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		-- goimport stopped working formating (see https://github.com/ray-x/go.nvim/issues/439), so for now we are using gofmt()
		require("go.format").goimport()
		-- require("go.format").gofmt()
	end,
	group = format_sync_grp,
})
vim.api.nvim_command("autocmd BufWritePost *.go lua vim.lsp.codelens.refresh()")

-- go_on_attach is different from on attach, as it is not doing the code formating. See above for the code-formatting
-- autocmd for all go files.
local go_on_attach = function(_client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	require("mappings").lsp(bufnr)

	vim.lsp.codelens.refresh()
end

nvim_lsp.gopls.setup({
	on_attach = go_on_attach,
	capabilities = capabilities,
	cmd = { "gopls", "serve" },
	-- cmd = { "gopls", "-vv", "-logfile=/tmp/gopls.log" },
	-- cmd = { "gopls", "-logfile=/tmp/gopls.log", "-vv", "-rpc.trace", "--debug=localhost:6060" },
	root_dir = function(fname)
		local has_lsp, lspconfig = pcall(require, "lspconfig")
		if has_lsp then
			local util = lspconfig.util
			return util.root_pattern("go.work", "go.mod", ".git")(fname) or util.path.dirname(fname)
		end
	end,
	filetypes = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
	init_options = {
		codelenses = {
			test = true,
		},
		buildFlags = { "-tags=systemtest,integrationtest" },
	},
	settings = {
		gopls = {
			buildFlags = {
				"-tags=systemtest,integrationtest",
			},
			-- templateExtensions = { "gotmpl" },
			usePlaceholders = true,
			analyses = {
				unreachable = true,
				unusedparams = true,
				useany = true,
				unusedwrite = true,
				ST1003 = true,
				ST1016 = true,
				ST1020 = true,
				ST1021 = true,
				undeclaredname = true,
				fillreturns = true,
				nonewvars = true,
				fieldalignment = false,
				shadow = true,
			},
			staticcheck = true,
			codelenses = {
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
				generate = true,
				test = true,
			},
			-- inlay hints are now supported by gopls, but we would need to write some infrastructure code to issue the correct
			-- requests. Sample could be seen in rust-tools.nvim
			-- Either wait for nvim go plugins to do this and try them, or write it myself...
			-- hints = {
			-- 	assignVariableTypes = true,
			-- 	compositeLiteralFields = true,
			-- 	compositeLiteralTypes = true,
			-- 	constantValues = true,
			-- 	functionTypeParameters = true,
			-- 	parameterNames = true,
			-- 	rangeVariableTypes = true,
			-- },
		},
	},
})

-- gopls end
--

-- https://github.com/someone-stole-my-name/yaml-companion.nvim
-- yaml companion, using the yaml-language-server and has autodetection for kubernetes yaml files
local cfg = require("yaml-companion").setup({
	-- Add any options here, or leave empty to use the default settings
	-- lspconfig = {
	--   cmd = {"yaml-language-server"}
	-- },
})
nvim_lsp.yamlls.setup(cfg)

-- golangci_lint_ls
--
-- check if there is a .golangci.yml file in the cicd-scripts subdirectory
-- if so, use it as config file for golangci-lint, otherwise use the default (local dir if present)
local golangci_lint_command = {
	"golangci-lint",
	"run",
	"--out-format",
	"json",
	"--config",
	"/Users/a1167272/go/golangci.yml",
}

-- local golangci_lint_config = vim.fn.getcwd() .. "/cicd-scripts/.golangci.yml"
-- if vim.fn.filereadable(golangci_lint_config) == 1 then
-- 	table.insert(golangci_lint_command, "--config")
-- 	table.insert(golangci_lint_command, golangci_lint_config)
-- end
require("lspconfig").golangci_lint_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "golangci-lint-langserver", "-debug", "true" },
	filetypes = { "go", "gomod" },
	init_options = {
		command = golangci_lint_command,
	},
})

-- lua language server
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])

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

vim.fn.sign_define("LspDiagnosticsSignError", { text = "" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "" })
