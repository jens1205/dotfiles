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

-- enable experimantal lua module loader (https://neovim.io/doc/user/lua.html#vim.loader)
-- replacement for https://github.com/lewis6991/impatient.nvim
vim.loader.enable()

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
vim.api.nvim_exec2(
	[[
  augroup Terminal
    autocmd!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonu
  augroup end
]],
	{ output = false }
)

-- Highlight on yank
vim.api.nvim_exec2(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	{ output = false }
)

vim.api.nvim_exec2(
	[[
  augroup Autoreload
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
    autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  augroup end
]],
	{ output = false }
)

-- set marks on last insert mode / modification
-- from https://stackoverflow.com/questions/28014665/how-to-go-to-the-last-edit-location-across-all-buffers-in-vim
vim.api.nvim_exec2(
	[[
    let g:detect_mod_reg_state = -1
    function! DetectRegChangeAndUpdateMark()
        let current_small_register = getreg('"-')
        let current_mod_register = getreg('""')
        if g:detect_mod_reg_state != current_small_register || 
                    \ g:detect_mod_reg_state != current_mod_register
            normal! mM
            let g:detect_mod_reg_state = current_small_register
        endif
    endfunction

    augroup LastEdits
    autocmd!
      " Mark I at the position where the last Insert mode occured across the buffer
      autocmd InsertLeave * execute 'normal! mI'
      
      " Mark M at the position when any modification happened in the Normal or Insert mode
      autocmd CursorMoved * call DetectRegChangeAndUpdateMark()
      autocmd InsertLeave * execute 'normal! mM'
    augroup end
    ]],
	{ output = false }
)
