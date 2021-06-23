require('packerInstall')

local use = require('packer').use
require('packer').startup(
    function()
        use 'wbthomason/packer.nvim'       -- Package manager

        use 'tpope/vim-fugitive'
        use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} }

        use 'tpope/vim-commentary'         -- "gc" to comment visual regions/lines
        use 'mkitt/tabline.vim'            -- pimp tab labels

        use 'junegunn/fzf'
        use 'junegunn/fzf.vim'

        use 'itchyny/lightline.vim'        -- Fancier statusline
        use { 'lukas-reineke/indent-blankline.nvim', branch="lua" } -- Add indentation guides even on blank lines

        use 'nvim-treesitter/nvim-treesitter' -- syntax highlighting

        use 'preservim/nerdtree'           -- File Explorer

        use 'windwp/nvim-autopairs'
        -- use 'jiangmiao/auto-pairs'

        use 'fatih/vim-go'                 -- golang

        -- LSP stuff
        use 'neovim/nvim-lspconfig'        -- Collection of configurations for built-in LSP client
        -- lspinstall is nice - but if a local language server is also installed, this leads to problems
        -- example: show documentation of golang fields always entered the hover window
        -- to fix we would need to configure nvim lsp to use only the path used by lspconfig
        -- use 'kabouzeid/nvim-lspinstall'    -- Install LSP-Servers in vim
        use 'hrsh7th/nvim-compe'           -- Autocompletion plugin
        use 'ray-x/lsp_signature.nvim'
        use 'SirVer/ultisnips'

        use 'tpope/vim-dispatch'
        use 'vim-test/vim-test'

        use 'jens1205/first-nvim-plugin'
        -- Themes
        use 'joshdick/onedark.vim'              -- Theme inspired by Atom
    end
)

require('settings')
require('indent_blankline_config')
require('lightline_config')
require('ultisnips_config')
require('gitsigns').setup()
require('nvim-autopairs').setup()  -- needs to be called before nvim-compe-config!
require('nvim-compe-config')
require('lsp-config')
require('lsp_signature').on_attach()
require('nvim-treesitter.configs').setup({ensure_installed = 'maintained', highlight = {enable = true}})
require('vim-go-config')
require('vim-test-config')
require('mappings')

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd[[colorscheme onedark]]

