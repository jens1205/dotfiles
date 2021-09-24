local cmp = require("cmp")
local luasnip = require("luasnip")

local function T(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local next = function(key)
	if vim.fn.pumvisible() == 1 then
		vim.fn.feedkeys(T("<C-n>"), "n")
	elseif luasnip.expand_or_jumpable() then
		vim.fn.feedkeys(T("<Plug>luasnip-expand-or-jump"), "")
	else
		vim.fn.feedkeys(T(key), "n")
	end
end

require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[Latex]",
			})[entry.source.name]
			return vim_item
		end,
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "emoji" },
		-- { name = "treesitter" },
		-- { name = "crates" },
	},
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-j>"] = cmp.mapping(function()
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(T("<C-n>"), "n")
			end
		end, {
			"i",
			"s",
		}),
		["<C-k>"] = cmp.mapping(function()
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(T("<C-p>"), "n")
			end
		end, {
			"i",
			"s",
		}),
		["<Tab>"] = cmp.mapping(function()
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(T("<C-n>"), "n")
			elseif luasnip.expand_or_jumpable() then
				vim.fn.feedkeys(T("<Plug>luasnip-expand-or-jump"), "")
			elseif check_backspace() then
				vim.fn.feedkeys(T("<Tab>"), "n")
			else
				vim.fn.feedkeys(T("<Tab>"), "n")
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(T("<C-p>"), "n")
			elseif luasnip.jumpable(-1) then
				vim.fn.feedkeys(T("<Plug>luasnip-jump-prev"), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),

		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
})
