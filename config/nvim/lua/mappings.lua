
--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true})
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true})

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true})

-- easier window movement
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Quickfix list
vim.api.nvim_set_keymap('n', '<leader>k', ':cprevious <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', ':cnext <CR>', { noremap = true, silent = true })

-- Location list
vim.api.nvim_set_keymap('n', '<leader>u', ':lprevious <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>i', ':lnext <CR>', { noremap = true, silent = true })

-- Plugin related stuff
vim.api.nvim_set_keymap('n', '<leader>nt', '::NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nj', '::NERDTreeFind<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nf', '::NerdTreeFocus<CR>', { noremap = true, silent = true })

-- Fzf
vim.api.nvim_set_keymap('n', '<leader>ft', ':Rg <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', ':Files <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Buffers <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':GFiles <CR>', { noremap = true, silent = true })



