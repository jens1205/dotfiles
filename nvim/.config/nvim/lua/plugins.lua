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
		use("lewis6991/impatient.nvim")

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
		-- use({
		-- 	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		-- 	config = function()
		-- 		-- Disable virtual_text since it's redundant due to lsp_lines.
		-- 		vim.diagnostic.config({
		-- 			virtual_text = false,
		-- 		})
		-- 		require("lsp_lines").setup()
		-- 	end,
		-- })
		use({
			"ggandor/leap.nvim",
			config = function()
				require("leap").add_default_mappings()
			end,
		})
		-- use("ggandor/lightspeed.nvim")
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
			requires = {
				{ "nvim-lua/popup.nvim" },
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope-ui-select.nvim" },
			},
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
			requires = { "p00f/nvim-ts-rainbow", "windwp/nvim-ts-autotag" },
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
					modules = {},
					ignore_install = {},
					sync_install = false,
					auto_install = false,
					indent = { enable = true },
					highlight = { enable = true },
					rainbow = {
						enable = true,
						extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
						max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
					},
					autotag = {
						enable = true,
					},
					textobjects = {
						-- syntax-aware textobjects
						enable = true,
						lsp_interop = {
							enable = true,
							peek_definition_code = {
								["<leader>Df"] = "@function.outer",
								["<leader>Dc"] = "@class.outer",
							},
						},
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["aC"] = "@class.outer",
							["iC"] = "@class.inner",
							["ac"] = "@conditional.outer",
							["ic"] = "@conditional.inner",
							["ae"] = "@block.outer",
							["ie"] = "@block.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
							["is"] = "@statement.inner",
							["as"] = "@statement.outer",
							["ad"] = "@comment.outer",
							["am"] = "@call.outer",
							["im"] = "@call.inner",
						},
						move = {
							enable = true,
							set_jumps = true, -- whether to set jumps in the jumplist
							goto_next_start = {
								["]m"] = "@function.outer",
								["]]"] = "@class.outer",
							},
							goto_next_end = {
								["]M"] = "@function.outer",
								["]["] = "@class.outer",
							},
							goto_previous_start = {
								["[m"] = "@function.outer",
								["[["] = "@class.outer",
							},
							goto_previous_end = {
								["[M"] = "@function.outer",
								["[]"] = "@class.outer",
							},
						},
						select = {
							enable = true,
							-- Automatically jump forward to textobj, similar to targets.vim
							lookahead = true,
							keymaps = {
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["ac"] = "@class.outer",
								["ic"] = "@class.inner",
							},
						},
						swap = {
							enable = true,
							swap_next = {
								["<leader>a"] = "@parameter.inner",
							},
							swap_previous = {
								["<leader>A"] = "@parameter.inner",
							},
						},
					},
				})
			end,
		})
		use("nvim-treesitter/nvim-treesitter-context")
		use({
			"nvim-treesitter/nvim-treesitter-textobjects",
			after = "nvim-treesitter",
			requires = "nvim-treesitter/nvim-treesitter",
		})

		use({
			"kyazdani42/nvim-tree.lua",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = function()
				require("mappings").nvimtree()
				require("nvim-tree").setup({
					respect_buf_cwd = true,
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
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"onsails/lspkind-nvim",
			},
		})
		use({
			"tzachar/cmp-tabnine",
			run = "./install.sh",
			config = function()
				local tabnine = require("cmp_tabnine.config")
				tabnine:setup({
					max_lines = 1000,
					max_num_results = 20,
					sort = true,
					run_on_every_keystroke = true,
					snippet_placeholder = "..",
					ignored_file_types = { -- default is not to ignore
						-- uncomment to ignore in lua:
						-- lua = true
					},
					show_prediction_strength = false,
				})
			end,
			requires = "hrsh7th/nvim-cmp",
		})

		use({
			"windwp/nvim-autopairs",
			config = function()
				require("config.nvim-autopairs")
			end,
		})

		use({
			"folke/trouble.nvim",
			config = function()
				require("mappings").trouble()
			end,
		})
		use({
			"jens1205/neotest",
			branch = "output_open_win",
			-- "nvim-neotest/neotest",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"antoinemadec/FixCursorHold.nvim",
				-- "nvim-neotest/neotest-go",
				"nvim-neotest/neotest-python",
				"rouge8/neotest-rust",
				{ "jens1205/neotest-go", branch = "root_output" },
			},
			config = function()
				-- get neotest namespace (create creates or returns namespace)
				local neotest_ns = vim.api.nvim_create_namespace("neotest")
				vim.diagnostic.config({
					virtual_text = {
						source = true,
						format = function(diagnostic)
							local message = diagnostic.message
								:gsub("\n", " ")
								:gsub("\t", " ")
								:gsub("%s+", " ")
								:gsub("^%s+", "")
							return message
						end,
					},
				}, neotest_ns)
				require("neotest").setup({
					consumers = {
						splitoutput = require("splitoutput"),
					},
					adapters = {
						require("neotest-python"),
						require("neotest-go")({
							experimental = {
								test_table = true,
							},
							args = { "-count=1", "-timeout=60s" },
						}),
						require("neotest-rust"),
					},
					diagnostic = {
						enabled = true,
					},
					output = {
						enabled = false,
						-- open_win = function()
						-- 	vim.notify("in open_win wrapper func")
						-- 	return Neotest_open_win()
						-- end,
					},
					splitoutput = {
						enabled = true,
						open_on_run = "short",
						-- open_on_run = "long",
					},
				})
			end,
		})
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
			"hashivim/vim-terraform",
		})

		use({
			"ray-x/go.nvim",
			ft = { "go", "gomod" },
			run = ":GoUpdateBinaries",
			config = function()
				require("go").setup({
					lsp_codelens = false,
					lsp_keymaps = false,
					lsp_inlay_hints = {
						enable = false,
					},
				})
				-- require("go").setup()
				require("config.go-nvim")
			end,
		})
		use("ray-x/guihua.lua")

		use({
			"someone-stole-my-name/yaml-companion.nvim",
			requires = {
				{ "neovim/nvim-lspconfig" },
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope.nvim" },
			},
			config = function()
				require("telescope").load_extension("yaml_schema")
			end,
		})

		use({
			"folke/neodev.nvim",
		})
		use({
			"simrat39/rust-tools.nvim",
			-- ft = "rs",
			requires = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				-- "nvim-telescope/telescope.nvim",
			},
			config = function()
				-- this is currently a copy from config/lsp.lua
				local on_attach = function(client, bufnr)
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

					require("mappings").lsp(bufnr)

					if client and client.supports_method("textDocument/formatting") then
						local format_enabled = true
						vim.api.nvim_buf_create_user_command(0, "FormatDisable", function()
							format_enabled = false
						end, {})
						vim.api.nvim_buf_create_user_command(0, "FormatEnable", function()
							format_enabled = true
						end, {})
						local lsp_augroup = "custom_lsp_augroup" .. bufnr
						vim.api.nvim_create_augroup(lsp_augroup, { clear = true })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = lsp_augroup,
							buffer = bufnr,
							callback = function()
								print("formatting", format_enabled)
								if format_enabled then
									vim.lsp.buf.format({ timeout_ms = 3000 })
								end
							end,
						})
					end
				end
				local opts = {
					server = {
						on_attach = on_attach,
					},
				}
				require("rust-tools").setup(opts)
				require("mappings").rusttools()
			end,
		})
		use("mfussenegger/nvim-jdtls")

		-- Themes
		use({ "navarasu/onedark.nvim" })
		use("folke/tokyonight.nvim")
	end)
end

packersetup()
install()
