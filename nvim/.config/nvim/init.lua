require('packerInstall')

vim.cmd "autocmd BufWritePost init.lua PackerCompile"

local use = require('packer').use
require('packer').startup(
    function()
        use 'wbthomason/packer.nvim'       -- Package manager

        use {'tpope/vim-fugitive'}
        use {'lewis6991/gitsigns.nvim'}
        use {"nvim-lua/plenary.nvim"}
        use {'TimUntersberger/neogit'}
        use {'sindrets/diffview.nvim'}

        use {'tpope/vim-commentary'}         -- "gc" to comment visual regions/lines
        use {'mkitt/tabline.vim'}            -- pimp tab labels

        -- Telescope
        use {"nvim-lua/popup.nvim"}
        use {"nvim-telescope/telescope.nvim"}
        use {"nvim-telescope/telescope-fzy-native.nvim"}
        use {"nvim-telescope/telescope-project.nvim"}

        use {'itchyny/lightline.vim'}        -- Fancier statusline
        use {'lukas-reineke/indent-blankline.nvim'} -- Add indentation guides even on blank lines
        -- use {'romgrk/barbar.nvim', requires = {"kyazdani42/nvim-web-devicons"}}

        use {'nvim-treesitter/nvim-treesitter'} -- syntax highlighting
        use {'p00f/nvim-ts-rainbow'}

        -- use {'preservim/nerdtree', opt = true}           -- File Explorer
        use {"kyazdani42/nvim-tree.lua"}
        use {"ahmedkhalf/lsp-rooter.nvim"} -- with this nvim-tree will follow you
        -- TODO remove when open on dir is supported by nvimtree
        use "kevinhwang91/rnvimr"

        use {'windwp/nvim-autopairs'}
        -- use 'jiangmiao/auto-pairs'

        use {'fatih/vim-go', ft="go"}                 -- golang

        -- LSP stuff
        use {'neovim/nvim-lspconfig'}        -- Collection of configurations for built-in LSP client
        -- lspinstall is nice - but if a local language server is also installed, this leads to problems
        -- example: show documentation of golang fields always entered the hover window
        -- to fix we would need to configure nvim lsp to use only the path used by lspconfig
        -- use 'kabouzeid/nvim-lspinstall'    -- Install LSP-Servers in vim
        use {'hrsh7th/nvim-compe'}           -- Autocompletion plugin
        use {'ray-x/lsp_signature.nvim'}
        use { "kyazdani42/nvim-web-devicons"}

        use { "folke/trouble.nvim"}

        -- use {'SirVer/ultisnips'}
        use { "hrsh7th/vim-vsnip"}
        use { "rafamadriz/friendly-snippets"}

        use {'tpope/vim-dispatch'}
        -- use {'vim-test/vim-test'}
        use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

        -- Themes
        use {'navarasu/onedark.nvim'}


    end
)
require('settings')
require('indent_blankline_config')
require('lightline_config')
require('ultisnips_config')
require("telescope-config")
require('gitsigns').setup()
require('nvim-autopairs').setup()  -- needs to be called before nvim-compe-config!
require('nvim-compe-config')
require('lsp-config')
require('lsp_signature').on_attach()
require('lsp-rooter').setup()
require('nvim-treesitter.configs').setup({
    ensure_installed = 'maintained',
    highlight = {enable = true},
    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
 })
require('vim-go-config')
-- require('vim-test-config')
require('neogit-config')
require('dap-config')

require('mappings')



--Set colorscheme (order is important here)
vim.o.termguicolors = true
-- vim.g.onedark_terminal_italics = 2
vim.cmd[[colorscheme onedark]]
