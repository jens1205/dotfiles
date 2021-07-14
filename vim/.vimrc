" Initial version was retrieved from https://missing.csail.mit.edu/2020/editors/
" Comments in Vimscript start with a `"`.

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Commandline at the bottom with 2 lines. Recommended by CoC 
set cmdheight=2

" Turn on syntax highlighting.
syntax on

" Set <Leader> key to be ',' instead of '\'
let mapleader = ","

" Updatetime in ms as recommended by CoC
set updatetime=300

" automatically load plugins for filetypes (introduced initially for golang)
filetype plugin indent on

" Disable the default Vim startup message.
set shortmess+=I

" Don't pass messages to |ins-completion-menu|. Recommended by CoC
set shortmess+=c

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set number relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" No more Arrow Key, deal with it
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Recommended by CoC
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Highlights findings of searches. A little annoying is that you have to turn
" it of with :noh if you don't want to see the findings highlighted anymore
" so I turn it off
"set hlsearch

" show line and column number
" set ruler

set spelllang=en_us

" shows a vertical bar - but currently in red, therefore commented out
"set colorcolumn=80

" not sure about these settings I have copied from some youtube video
" set clipboard=unnamed 
" set noscrollbind
" set wildmenu
" set autochdir


" hi Search cterm=NONE ctermfg=black ctermbg=red


" shows helpful information on top of explorer - not disabled in the beginning
"let g:netrw_banner = 0
let g:netrw_liststyle = 3

" ... other plugins here
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline' " https://github.com/vim-airline/vim-airline
Plug 'tpope/vim-commentary'    " https://github.com/tpope/vim-commentary
Plug 'airblade/vim-gitgutter'  " https://github.com/airblade/vim-gitgutter
Plug 'mkitt/tabline.vim'       " https://github.com/mkitt/tabline.vim
Plug '/usr/local/opt/fzf'      " https://github.com/junegunn/fzf/blob/master/README-VIM.md
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'      " https://github.com/tpope/vim-fugitive
Plug 'preservim/nerdtree'      " https://github.com/preservim/nerdtree
Plug 'jiangmiao/auto-pairs'    " https://github.com/jiangmiao/auto-pairs

" Golang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' } " https://github.com/fatih/vim-go
Plug 'neoclide/coc.nvim', {'branch': 'release'}     " https://github.com/neoclide/coc.nvim

" Theme
Plug 'NLKNguyen/papercolor-theme' "https://github.com/NLKNguyen/papercolor-theme

" Initialize plugin system
call plug#end()

" normal mode mappings
nnoremap <silent><leader>nt :NERDTreeToggle<CR>
nnoremap <silent><leader>nj :NERDTreeFind<CR>
nnoremap <silent><leader>nf :NERDTreeFocus<CR>
nnoremap <silent><leader>ff :Files<CR>
nnoremap <silent><leader>fg :GFiles<CR>
nnoremap <silent><leader>fb :Buffers<CR>
nnoremap <silent><C-f> :Rg<CR>
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l

" Set cursorline for active split / window. Alternative would be
" https://github.com/TaDaa/vimade or https://github.com/blueyed/vim-diminactive/
autocmd WinEnter * setlocal cursorline
autocmd BufEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
setlocal cursorline

" papercolor-theme

set termguicolors
set background=dark
colorscheme PaperColor

"-- papercolor-theme END
"
runtime coc.vim
runtime nerdtree.vim
