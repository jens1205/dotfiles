
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

-- better indenting
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap('x', 'K', ':move \'<-2<CR>gv-gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'J', ':move \'>+1<CR>gv-gv', {noremap = true, silent = true})

-- Quickfix list
vim.api.nvim_set_keymap('n', '<leader>k', ':cprevious <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', ':cnext <CR>', { noremap = true, silent = true })

-- Location list
vim.api.nvim_set_keymap('n', '<leader>u', ':lprevious <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>i', ':lnext <CR>', { noremap = true, silent = true })

-- Plugin related stuff
vim.api.nvim_set_keymap('n', '<leader>nt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nj', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>nt', '::NERDTreeToggle<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>nj', '::NERDTreeFind<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>nf', '::NerdTreeFocus<CR>', { noremap = true, silent = true })

-- Fzf
vim.api.nvim_set_keymap('n', '<leader>ft', ':Rg <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', ':Files <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Buffers <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':GFiles <CR>', { noremap = true, silent = true })

-- Telescope
vim.api.nvim_set_keymap('n', '<Leader>tf', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tof', ':Telescope oldfiles<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tgs', ':Telescope git_status<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tgb', ':Telescope git_branches<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tgc', ':Telescope git_commits<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tgC', ':Telescope git_bcommits<CR>', {noremap = true, silent = true}) -- cuurent file
vim.api.nvim_set_keymap('n', '<Leader>tld', ':Telescope lsp_workspace_diagnostics<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tlD', ':Telescope lsp_document_diagnostics<cr>', {noremap = true, silent = true})

-- Trouble
vim.api.nvim_set_keymap('n', '<leader>dt', ':TroubleToggle<CR>', { noremap = true, silent = true })


