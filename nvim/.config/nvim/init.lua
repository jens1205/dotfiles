require('plugins')

require('settings')

require('mappings').general()
require('dbg')

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd[[colorscheme onedark]]
