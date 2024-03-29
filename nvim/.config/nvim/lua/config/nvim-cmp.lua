local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

-- local function T(str)
-- 	return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
-- local has_words_before = function()
-- 	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
-- 	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end
local select_next = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
		-- vim.fn.feedkeys(T("<Plug>luasnip-expand-or-jump"), "")
		-- elseif has_words_before() then
		-- 	cmp.complete()
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
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end, {
	"i",
	"s",
})
local jump = cmp.mapping(function(fallback)
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		fallback()
	end
end, {
	"i",
	"s",
})
local jump_back = cmp.mapping(function(fallback)
	if luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end, {
	"i",
	"s",
})

cmp.setup({
	-- preselect = cmp.PreselectMode.None,
	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			local prefix = require("lspkind").presets.default[vim_item.kind] or ""
			vim_item.kind = prefix .. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				emoji = "[Emoji]",
				path = "[Path]",
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
		{ name = "buffer", keyword_length = 5 },
		{ name = "emoji" },
		{ name = "cmp_tabnine" },
		{ name = "nvim_lsp_signature_help" },
		-- { name = "treesitter" },
		-- { name = "crates" },
	},
	mapping = {
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		-- ["<Tab>"] = select_next,
		-- ["<S-Tab>"] = select_prev,
		["<Tab>"] = cmp.config.disable,
		["<S-Tab>"] = cmp.config.disable,
		["<C-j>"] = select_next,
		["<C-k>"] = select_prev,
		["<C-l>"] = jump,
		["<C-h>"] = jump_back,
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			-- behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<S-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
	},
	-- experimental = {
	-- 	native_menu = false,
	-- 	ghost_text = false,
	-- },
})

-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
