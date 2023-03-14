-- Global settings
vim.o.splitright = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.colorcolumn = "120"

vim.o.termguicolors = true -- set term gui colors most terminals support this

--Incremental live completion
vim.o.inccommand = "nosplit"

--Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

vim.cmd("filetype plugin indent on")

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250

--Add map to enter paste mode
vim.o.pastetoggle = "<F3>"

vim.o.clipboard = "unnamedplus" -- Copy paste between vim and everything else
vim.o.showmode = false -- We don't need to see things like -- INSERT -- anymore

-- No Backup / Swapfile
vim.o.backup = false
vim.o.writebackup = false

-- Set completeopt to have a better completion experience
-- vim.o.completeopt="menuone,noinsert"
vim.o.completeopt = "menu,menuone,noselect"
-- vim.o.completeopt = "menu,noselect"

vim.o.guifont = "FiraCode Nerd Font:h17"

--Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.signcolumn = "yes"

vim.wo.cursorline = true
-- lua seems to have no support for autocmd, so we use nvim_command
vim.api.nvim_command([[
autocmd WinEnter * setlocal cursorline
autocmd BufEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
]])

--Remap space as leader key
-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Change preview window location
-- vim.g.splitbelow = true

vim.bo.spelllang = "en_us"

-- Mac OS X clipboard sharing
vim.api.nvim_set_option("clipboard", "unnamed")

--Remap escape to leave terminal mode
vim.api.nvim_exec(
	[[
  augroup Terminal
    autocmd!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonu
  augroup end
]],
	false
)

-- Highlight on yank
vim.api.nvim_exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	false
)

vim.api.nvim_exec(
	[[
  augroup Autoreload
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
    autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  augroup end
]],
	false
)
