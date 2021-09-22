require('plugins')

require('settings')

require('mappings').general()
require('dbg')
-- require'mappings'.restnvim()
vim.cmd[[
    command FormatJson :%!jq .
]]
--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd[[colorscheme onedark]]

