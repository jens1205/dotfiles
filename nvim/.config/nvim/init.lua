require('packerInstall')

-- vim.cmd "autocmd BufWritePost init.lua PackerCompile"
vim.cmd "au! BufWritePost */<plugins-dir>/*.lua lua require('packer').compile()"

local use = require('packer').use
require('packer').startup(
    function()
        use 'wbthomason/packer.nvim'       -- Package manager

        -- use {"nvim-lua/plenary.nvim"}
        -- use { "kyazdani42/nvim-web-devicons"}

        use {'tpope/vim-fugitive'}
        use {'lewis6991/gitsigns.nvim',
            requires = { 'nvim-lua/plenary.nvim' },
            config = function()
                require('gitsigns').setup()
            end}
        use {'TimUntersberger/neogit',
            requires = 'nvim-lua/plenary.nvim',
            config = function()
                require('neogit-config')
            end}
        use {'sindrets/diffview.nvim'}

        use {'tpope/vim-commentary'}         -- "gc" to comment visual regions/lines
        use {'mkitt/tabline.vim'}            -- pimp tab labels

        -- Telescope
        use {"nvim-telescope/telescope.nvim",
            requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
            config = function()
                require("telescope-config")
            end}
        use {"nvim-telescope/telescope-fzy-native.nvim"}
        use {"nvim-telescope/telescope-project.nvim"}

        use {'itchyny/lightline.vim',  -- Fancier statusline
            config = function()
                require('lightline_config')
            end}

        use {'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
            config = function()
                require('indent_blankline_config')
            end}

        -- use {'romgrk/barbar.nvim', requires = {"kyazdani42/nvim-web-devicons"}}

        use {'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = function()
                require('nvim-treesitter.configs').setup({
                    ensure_installed = 'maintained',
                    highlight = {enable = true},
                    rainbow = {
                        enable = true,
                        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
                        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
                    },
                 })
            end} -- syntax highlighting
        use {'p00f/nvim-ts-rainbow'}

        use {"kyazdani42/nvim-tree.lua", requires = {'kyazdani42/nvim-web-devicons'}}
        use {"ahmedkhalf/lsp-rooter.nvim", config = function() require('lsp-rooter').setup() end} -- with this nvim-tree will follow you

        use {'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end }  -- needs to be called before nvim-compe-config!

        use {'fatih/vim-go', ft="go", run = ':GoInstallBinaries', config = function() require('vim-go-config') end }                 -- golang

        -- LSP stuff
        use {'neovim/nvim-lspconfig', config = function()
            require('lsp-config') end}        -- Collection of configurations for built-in LSP client
        -- lspinstall is nice - but if a local language server is also installed, this leads to problems
        -- example: show documentation of golang fields always entered the hover window
        -- to fix we would need to configure nvim lsp to use only the path used by lspconfig
        -- use 'kabouzeid/nvim-lspinstall'    -- Install LSP-Servers in vim
        use {'hrsh7th/nvim-compe', config = function() require('nvim-compe-config') end }           -- Autocompletion plugin
        use {'ray-x/lsp_signature.nvim', config = function() require "lsp_signature".setup() end}

        use { "folke/trouble.nvim"}

        -- use {'SirVer/ultisnips', config = function() require('ultisnips_config') end}
        use { "hrsh7th/vim-vsnip"}
        use { "rafamadriz/friendly-snippets"}

        use {'tpope/vim-dispatch'}
        -- use {'vim-test/vim-test', config = function() require('vim-test-config') end}
        use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"}, config = function() require('dap-config') end }

        -- Themes
        use {'navarasu/onedark.nvim'}


    end
)
-- require('vim-go-config')
require('settings')

require('mappings')



--Set colorscheme (order is important here)
vim.o.termguicolors = true
-- vim.g.onedark_terminal_italics = 2
vim.cmd[[colorscheme onedark]]
