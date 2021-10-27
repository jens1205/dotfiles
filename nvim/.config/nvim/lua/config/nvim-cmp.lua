local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

local function T(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local select_next = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		vim.fn.feedkeys(T("<Plug>luasnip-expand-or-jump"), "")
	else
		fallback()
	end
end, {
	"i",
	"s",
})
local select_prev = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	else
		fallback()
	end
end, {
	"i",
	"s",
})

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
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<Tab>"] = select_next,
		["<C-j>"] = select_next,
		["<S-Tab>"] = select_prev,
		["<C-k>"] = select_prev,
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
})
