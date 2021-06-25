require('packerInstall')

local use = require('packer').use
require('packer').startup(
    function()
        use 'wbthomason/packer.nvim'       -- Package manager

        use {'tpope/vim-fugitive', opt = true}
        use {'lewis6991/gitsigns.nvim', opt = true, requires = {'nvim-lua/plenary.nvim'} }

        use {'tpope/vim-commentary', opt = true}         -- "gc" to comment visual regions/lines
        use {'mkitt/tabline.vim', opt = true}            -- pimp tab labels

        use {'junegunn/fzf', opt = true}
        use {'junegunn/fzf.vim', opt = true}

        use {'itchyny/lightline.vim', opt = true}        -- Fancier statusline
        use { 'lukas-reineke/indent-blankline.nvim', branch="lua" } -- Add indentation guides even on blank lines

        use {'nvim-treesitter/nvim-treesitter', opt = true} -- syntax highlighting
        use {"ahmedkhalf/lsp-rooter.nvim", opt = true} -- with this nvim-tree will follow you
        use {'p00f/nvim-ts-rainbow', opt = true}

        -- use {'preservim/nerdtree', opt = true}           -- File Explorer
        use {"kyazdani42/nvim-tree.lua", opt = true}
        use {"ahmedkhalf/lsp-rooter.nvim", opt = true} -- with this nvim-tree will follow you
        -- TODO remove when open on dir is supported by nvimtree
        use "kevinhwang91/rnvimr"

        use {'windwp/nvim-autopairs', opt = true}
        -- use 'jiangmiao/auto-pairs'

        use {'fatih/vim-go', opt = true}                 -- golang

        -- LSP stuff
        use {'neovim/nvim-lspconfig', opt = true}        -- Collection of configurations for built-in LSP client
        -- lspinstall is nice - but if a local language server is also installed, this leads to problems
        -- example: show documentation of golang fields always entered the hover window
        -- to fix we would need to configure nvim lsp to use only the path used by lspconfig
        -- use 'kabouzeid/nvim-lspinstall'    -- Install LSP-Servers in vim
        use {'hrsh7th/nvim-compe', opt = true}           -- Autocompletion plugin
        use {'ray-x/lsp_signature.nvim', opt = true}
	use { "kyazdani42/nvim-web-devicons", opt = true}

        use { "folke/trouble.nvim", opt = true }

        use {'SirVer/ultisnips', opt = true }

        use {'tpope/vim-dispatch', opt = true}
        use {'vim-test/vim-test', opt = true}

        -- Themes
        -- use 'joshdick/onedark.vim'              -- Theme inspired by Atom
        use {'navarasu/onedark.nvim', opt = true}


        require_plugin("tpope/vim-fugitive")
        require_plugin("lewis6991/gitsigns.nvim")
        require_plugin("tpope/vim-commentary")
	require_plugin("tabline.vim")
	require_plugin("fzf")
	require_plugin("fzf.vim")
	require_plugin("lightline.vim")
	require_plugin("indent-blankline.nvim")
	require_plugin("nvim-treesitter")
	require_plugin("lsp-rooter.nvim")
	require_plugin("nvim-ts-rainbow")
	require_plugin("nvim-tree.lua")
	require_plugin("lsp-rooter.nvim")
	require_plugin("rnvimr")
	require_plugin("nvim-autopairs")
	require_plugin("vim-go")
	require_plugin("nvim-lspconfig")
	require_plugin("nvim-compe")
	require_plugin("lsp_signature.nvim")
	require_plugin("trouble.nvim")
	require_plugin("ultisnips")
	-- require_plugin("vim-disptach")
	-- require_plugin("vim-test")
	require_plugin("onedark.nvim")

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
require('vim-test-config')
require('mappings')

--Set colorscheme (order is important here)
vim.o.termguicolors = true
-- vim.g.onedark_terminal_italics = 2
vim.cmd[[colorscheme onedark]]
