local function packersetup()
    local execute = vim.api.nvim_command

    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
    end

    vim.cmd([[
      augroup Packer
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
      augroup end
    ]], false)
end

local function install()
    local use = require('packer').use
    require('packer').startup(
        function()
            use 'wbthomason/packer.nvim'       -- Package manager

            use {'tpope/vim-fugitive'}
            use {'lewis6991/gitsigns.nvim',
                requires = { 'nvim-lua/plenary.nvim' },
                config = function()
                    require('gitsigns').setup()
                end}
            use {'TimUntersberger/neogit',
                requires = 'nvim-lua/plenary.nvim',
                config = function()
                    require('config.neogit')
                end}
            use {'sindrets/diffview.nvim'}

            use {'tpope/vim-commentary'}         -- "gc" to comment visual regions/lines
            -- use {'mkitt/tabline.vim'}            -- pimp tab labels

            -- Telescope
            use {"nvim-telescope/telescope.nvim",
                requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
                config = function()
                    require("config.telescope")
                end}
            use {"nvim-telescope/telescope-fzy-native.nvim"}
            use {"nvim-telescope/telescope-project.nvim"}

            use {'itchyny/lightline.vim',  -- Fancier statusline
                config = function()
                    require('config.lightline')
                end}

            use {'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
                config = function()
                    require('config.indent-blankline')
                end}

            use {'nvim-treesitter/nvim-treesitter',
                requires = {'p00f/nvim-ts-rainbow'},
                run = ':TSUpdate',
                config = function()
                            require('nvim-treesitter.configs').setup({
                                ensure_installed = 'maintained',
                                indent = {enable = true},
                                highlight = {enable = true},
                                rainbow = {
                                    enable = true,
                                    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
                                    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
                                },
                             })
                         end
            }

            use {"kyazdani42/nvim-tree.lua",
                requires = {'kyazdani42/nvim-web-devicons'},
                config = function()
                            vim.g.nvim_tree_follow = 1
                            vim.g.nvim_tree_highlight_opened_files = 1
                            require'mappings'.nvimtree()
                         end
            }

            use {"ahmedkhalf/lsp-rooter.nvim", config = function() require('lsp-rooter').setup() end} -- with this nvim-tree will follow you

            use {'windwp/nvim-autopairs', config = function() require('config.nvim-autopairs') end }  -- needs to be called before nvim-compe-config!

            use {'fatih/vim-go', ft="go", run = ':GoInstallBinaries', config = function() require('config.vim-go') end }                 -- golang

            -- LSP stuff
            use {'neovim/nvim-lspconfig', config = function()
               require('config.lsp') end}        -- Collection of configurations for built-in LSP client
            --
            -- lspinstall is nice - but if a local language server is also installed, this leads to problems
            -- example: show documentation of golang fields always entered the hover window
            -- to fix we would need to configure nvim lsp to use only the path used by lspconfig
            -- use 'kabouzeid/nvim-lspinstall'    -- Install LSP-Servers in vim
            --
            use {'hrsh7th/nvim-compe', config = function() require('config.nvim-compe') end }           -- Autocompletion plugin
            use {'ray-x/lsp_signature.nvim', config = function() require "lsp_signature".setup() end}

            use { "folke/trouble.nvim",
                 config = function()
                            require'mappings'.trouble()
                          end
            }

            use { "hrsh7th/vim-vsnip"}
            use { "rafamadriz/friendly-snippets"}

            -- use {'tpope/vim-dispatch'}
            -- use {'vim-test/vim-test', config = function() require('config.vim-test') end}
             -- use { "rcarriga/vim-ultest",
             --        config = "require('config.ultest')",
             --        run = ":UpdateRemotePlugins",
             --        requires = {"vim-test/vim-test"},
             --        opt = true,
             --        cmd = {'Ultest'},
            -- }

            -- DAP
            use {'mfussenegger/nvim-dap'}
            use {'nvim-telescope/telescope-dap.nvim'}
            use {'theHamsta/nvim-dap-virtual-text'}
            use {'rcarriga/nvim-dap-ui'}
            -- use {'Pocco81/DAPInstall.nvim'}
            use {'jbyuki/one-small-step-for-vimkind'}

            use {
                -- 'jens1205/rest.nvim',
                -- branch = 'non-json-body',
                'NTBBloodbath/rest.nvim',
                requires = { 'nvim-lua/plenary.nvim' },
                config = function()
                    require('rest-nvim').setup()
                    require('mappings').restnvim()
                end
            }

            -- Themes
            use {'navarasu/onedark.nvim'}


        end
    )

end

packersetup()
install()
