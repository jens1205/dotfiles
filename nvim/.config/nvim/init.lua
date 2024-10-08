_G.__luacache_config = {
	chunks = {
		enable = true,
		path = vim.fn.stdpath("cache") .. "/luacache_chunks",
	},
	modpaths = {
		enable = true,
		path = vim.fn.stdpath("cache") .. "/luacache_modpaths",
	},
}
require("settings")
require("config.lazy")

require("mappings").general()
require("dbg")

vim.cmd([[
    command FormatJson :%!jq .
]])
--Set colorscheme (order is important here)
vim.o.termguicolors = true
-- vim.cmd[[colorscheme onedark]]
vim.g.tokyonight_style = "night"
vim.cmd([[colorscheme tokyonight]])
