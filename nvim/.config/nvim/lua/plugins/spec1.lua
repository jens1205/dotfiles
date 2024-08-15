return {
	{
		"tpope/vim-fugitive",
		lazy = false,
		keys = {
			{ "<leader>gs", ":Git<CR>" }, -- like git status
			{ "<leader>gdd", ":Gvdiffsplit<CR>" }, -- git diff current file
			{ "<leader>gdl", ":Git difftool<CR>" }, -- git diff output into quickfix list
			{ "<leader>gm", ":Gvdiffsplit!<CR>" }, -- git diff and merge current file
			{ "<leader>ga", ":diffget //2<CR>" },
			{ "<leader>g;", ":diffget //3<CR>" },
			{ "<leader>gc", ":0Gclog<CR>" }, -- commit history of current file into quickfix list
		},
		config = function()
			vim.api.nvim_create_user_command("Review", ":lua require('mappings').git_review(<q-args>)", { nargs = "?" })
		end,
	},

	{
		"shumphrey/fugitive-gitlab.vim",
		lazy = false,
		config = function()
			vim.g.fugitive_gitlab_domains = { "https://gitlab.devops.telekom.de/" }
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					require("mappings").gitsigns(bufnr)
				end,
			})
		end,
	},
	{
		"ggandor/leap.nvim",
		lazy = false,
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{
		"szw/vim-maximizer",
		lazy = false,
		config = function()
			require("mappings").maximizer()
		end,
	},
	{
		"tpope/vim-commentary",
		lazy = false,
		config = function()
			vim.api.nvim_command("autocmd FileType toml setlocal commentstring=#\\ %s")
			vim.api.nvim_command("autocmd FileType http setlocal commentstring=#\\ %s")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		lazy = false,
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			require("config.telescope")
		end,
	},
	{ "nvim-telescope/telescope-fzy-native.nvim", lazy = false },

	{
		"itchyny/lightline.vim", -- Fancier statusline
		lazy = false,
		config = function()
			require("config.lightline")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
		config = function()
			require("config.indent-blankline")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"p00f/nvim-ts-rainbow",
			"windwp/nvim-ts-autotag",
		},
		build = ":TSUpdate",
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
	},
	{ "nvim-treesitter/nvim-treesitter-context", lazy = false },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = false,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
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
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("config.lsp")
		end,
	},
	{ "rafamadriz/friendly-snippets" },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
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
		config = function()
			require("config.nvim-cmp")
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("config.nvim-autopairs")
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"sbdchd/neoformat",
		config = function()
			vim.api.nvim_command([[
                         augroup neoformatSave
                            autocmd BufWritePre *.html,*.lua Neoformat
                         augroup END
                    ]])
		end,
	},
	{ "mfussenegger/nvim-dap" },
	{ "nvim-telescope/telescope-dap.nvim" },
	{ "theHamsta/nvim-dap-virtual-text" },
	{ "rcarriga/nvim-dap-ui", dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	} },
	{ "jbyuki/one-small-step-for-vimkind" },
	{
		"github/copilot.vim",
		config = function()
			require("mappings").copilot()
		end,
	},
	{ "hashivim/vim-terraform" },
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "go", "gomod" },
		event = { "CmdlineEnter" },
		build = ':lua require("go.install").update_all_sync()',
		config = function()
			-- had to disable the following, as otherwise every go to definition to an external dependency
			-- showed an error once
			-- see https://github.com/ray-x/go.nvim/issues/434 for details
			-- require("go").setup()
			require("go").setup({
				-- default is gofumpt, but this changes to much to our codebase and is sometimes also annoying
				-- especially when dealing with long lines in an interface
				gofmt = "gopls",
				lsp_codelens = false,
				lsp_keymaps = false,
				lsp_inlay_hints = {
					enable = false,
				},
			})
			require("config.go-nvim")
		end,
	},
	{
		"someone-stole-my-name/yaml-companion.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("yaml_schema")
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{ "mfussenegger/nvim-jdtls" },

	-- Themes
	{ "navarasu/onedark.nvim" },
	{ "folke/tokyonight.nvim" },
}
