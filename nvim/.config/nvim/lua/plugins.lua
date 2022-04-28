local function packersetup()
	local execute = vim.api.nvim_command

	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	end

	vim.cmd(
		[[
      augroup Packer
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
      augroup end
    ]],
		false
	)
end

local function install()
	local use = require("packer").use
	require("packer").startup(function()
		use("wbthomason/packer.nvim") -- Package manager

		use({
			"tpope/vim-fugitive",
			config = function()
				require("mappings").fugitive()
			end,
		})
		use({
			"shumphrey/fugitive-gitlab.vim",
			config = function()
				vim.g.fugitive_gitlab_domains = { "https://gitlab.devops.telekom.de/" }
			end,
		})
		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup({
					on_attach = function(bufnr)
						require("mappings").gitsigns(bufnr)
					end,
				})
			end,
		})
		use("ggandor/lightspeed.nvim")
		-- use({
		-- 	"TimUntersberger/neogit",
		-- 	requires = "nvim-lua/plenary.nvim",
		-- 	config = function()
		-- 		require("config.neogit")
		-- 	end,
		-- })
		-- use({ "sindrets/diffview.nvim" })
		use({
			"szw/vim-maximizer",
			config = function()
				require("mappings").maximizer()
			end,
		})

		use({
			"tpope/vim-commentary",
			config = function()
				vim.api.nvim_command("autocmd FileType toml setlocal commentstring=#\\ %s")
				vim.api.nvim_command("autocmd FileType http setlocal commentstring=#\\ %s")
			end,
		}) -- "gc" to comment visual regions/lines
		-- use {'mkitt/tabline.vim'}            -- pimp tab labels

		-- Telescope
		use({
			"nvim-telescope/telescope.nvim",
			requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
			config = function()
				require("config.telescope")
			end,
		})
		use({ "nvim-telescope/telescope-fzy-native.nvim" })

		use({
			"itchyny/lightline.vim", -- Fancier statusline
			config = function()
				require("config.lightline")
			end,
		})

		use({
			"lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
			config = function()
				require("config.indent-blankline")
			end,
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			requires = { "p00f/nvim-ts-rainbow" },
			run = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"bash",
						"css",
						"go",
						"html",
						"http",
						"java",
						"javascript",
						"json",
						"lua",
						"markdown",
						"python",
						"rust",
						"toml",
						"typescript",
						"yaml",
					},
					indent = { enable = true },
					highlight = { enable = true },
					rainbow = {
						enable = true,
						extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
						max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
					},
				})
			end,
		})

		use({
			"kyazdani42/nvim-tree.lua",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = function()
				vim.g.nvim_tree_respect_buf_cwd = 1
				require("mappings").nvimtree()
				require("nvim-tree").setup({
					disable_netrw = false,
					diagnostics = {
						enable = true,
					},
					update_cwd = false,
					update_focused_file = {
						-- enables the feature
						enable = true,
						-- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
						-- only relevant when `update_focused_file.enable` is true
						update_cwd = false,
						-- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
						-- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
						ignore_list = {},
					},
				})
			end,
		})
		-- LSP stuff
		use({
			"neovim/nvim-lspconfig",
			config = function()
				require("config.lsp")
			end,
		}) -- Collection of configurations for built-in LSP client
		--
		-- lspinstall is nice - but if a local language server is also installed, this leads to problems
		-- example: show documentation of golang fields always entered the hover window
		-- to fix we would need to configure nvim lsp to use only the path used by lspconfig
		-- use 'kabouzeid/nvim-lspinstall'    -- Install LSP-Servers in vim
		--
		use({ "rafamadriz/friendly-snippets" })
		use({
			"hrsh7th/nvim-cmp",
			config = function()
				require("config.nvim-cmp")
			end,
			requires = {
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-emoji",
				"onsails/lspkind-nvim",
			},
		})

		use({
			"windwp/nvim-autopairs",
			config = function()
				require("config.nvim-autopairs")
			end,
		}) -- should be after cmp.setup
		use({
			"ray-x/lsp_signature.nvim",
			-- config = function()
			-- require("lsp_signature").setup({ floating_window = false })
			-- end,
		})

		use({
			"folke/trouble.nvim",
			config = function()
				require("mappings").trouble()
			end,
		})
		-- use {'vim-test/vim-test', config = function() require('config.vim-test') end}
		-- use { "rcarriga/vim-ultest",
		--        config = "require('config.ultest')",
		--        run = ":UpdateRemotePlugins",
		--        requires = {"vim-test/vim-test"},
		--        opt = true,
		--        cmd = {'Ultest'},
		-- }
		--
		use({
			"sbdchd/neoformat",
			config = function()
				vim.api.nvim_command([[
                         augroup neoformatSave
                            autocmd BufWritePre *.html,*.lua Neoformat
                         augroup END
                    ]])
			end,
		})

		-- DAP
		use({ "mfussenegger/nvim-dap" })
		use({ "nvim-telescope/telescope-dap.nvim" })
		use({ "theHamsta/nvim-dap-virtual-text" })
		use({ "rcarriga/nvim-dap-ui" })
		-- use {'Pocco81/DAPInstall.nvim'}
		use({ "jbyuki/one-small-step-for-vimkind" })

		-- language specific things
		use({
			"github/copilot.vim",
			config = function()
				require("mappings").copilot()
			end,
		})

		use({
			-- 'jens1205/rest.nvim',
			-- branch = 'highlight-request',
			"NTBBloodbath/rest.nvim",
			ft = "http",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("rest-nvim").setup()
				require("mappings").restnvim()
			end,
		})
		use({
			"fatih/vim-go",
			ft = "go",
			run = ":GoInstallBinaries",
			config = function()
				require("config.vim-go")
			end,
		}) -- golang

		-- use({
		-- 	"ray-x/go.nvim",
		-- 	ft = "go",
		-- 	config = function()
		-- 		require("go").setup()
		-- 	end,
		-- })
		use({
			"simrat39/rust-tools.nvim",
			ft = "rs",
			requires = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
			config = function()
				local on_attach = function(_client, bufnr)
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

					require("mappings").lsp(bufnr)
				end
				local opts = {
					server = {
						on_attach = on_attach,
					},
				}
				require("rust-tools").setup(opts)
				vim.api.nvim_command("autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)")
			end,
		})
		use("mfussenegger/nvim-jdtls")

		-- Themes
		use({ "navarasu/onedark.nvim" })
	end)
end

packersetup()
install()
