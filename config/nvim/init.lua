-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
end

vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]], false)
-- end install packer

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'       -- Package manager

  use 'tpope/vim-fugitive'           -- Git commands in nvim
  -- Add git related info in the signs columns and popups
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} }
  -- disabled - we try gitsigns although it is very new
  -- use 'airblade/vim-gitgutter'       -- show Git diff in the sign column
  --
  use 'tpope/vim-commentary'         -- "gc" to comment visual regions/lines
  -- temporary disable gutentags. Maybe has to be enabled for go-files in vim-go?
  -- use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  use 'mkitt/tabline.vim'            -- pimp tab labels
  -- UI to select things (files, grep results, open buffers...)
  -- use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  -- use '/usr/local/opt/fzf'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  use 'itchyny/lightline.vim'        -- Fancier statusline
  -- Add indentation guides even on blank lines
  use { 'lukas-reineke/indent-blankline.nvim', branch="lua" }

  use 'nvim-treesitter/nvim-treesitter' -- syntax highlighting

  use 'preservim/nerdtree'           -- File Explorer

  use 'jiangmiao/auto-pairs'

  use 'fatih/vim-go'                 -- golang

  -- LSP stuff
  use 'neovim/nvim-lspconfig'        -- Collection of configurations for built-in LSP client
  -- lspinstall is nice - but if a local language server is also installed, this leads to problems
  -- example: show documentation of golang fields always entered the hover window
  -- use 'kabouzeid/nvim-lspinstall'    -- Install LSP-Servers in vim
  use 'hrsh7th/nvim-compe'           -- Autocompletion plugin
  use 'SirVer/ultisnips'

  use 'ThePrimeagen/vim-be-good'

  -- Themes
  use 'joshdick/onedark.vim'              -- Theme inspired by Atom
end)

--Incremental live completion
vim.o.inccommand = "nosplit"

--Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

--Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
--vim.cmd[[set undofile]]

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn="yes"


--Set statusbar
vim.g.lightline = { colorscheme = 'onedark';
      active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } };
      component_function = { gitbranch = 'fugitive#head', };
}

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true})
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true})

--Remap escape to leave terminal mode
vim.api.nvim_exec([[
  augroup Terminal
    autocmd!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonu
  augroup end
]], false)

--Add map to enter paste mode
vim.o.pastetoggle="<F3>"

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile'}
vim.g.indent_blankline_char_highlight = 'LineNr'

-- ultisnips
vim.g.UltiSnipsExpandTrigger = "<C-s>"
vim.g.UltiSnipsJumpForwardTrigger = "<C-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"

-- -- Toggle to disable mouse mode and indentlines for easier paste
-- ToggleMouse = function()
--   if vim.o.mouse == 'a' then
--     vim.cmd[[IndentBlanklineDisable]]
--     vim.wo.signcolumn='no'
--     vim.o.mouse = 'v'
--     vim.wo.number = false
--     print("Mouse disabled")
--   else
--     vim.cmd[[IndentBlanklineEnable]]
--     vim.wo.signcolumn='yes'
--     vim.o.mouse = 'a'
--     vim.wo.number = true
--     print("Mouse enabled")
--   end
-- end

-- vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua ToggleMouse()<cr>', { noremap = true })

-- -- Telescope
-- require('telescope').setup {
--   defaults = {
--     mappings = {
--       i = {
--         ["<C-u>"] = false,
--         ["<C-d>"] = false,
--       },
--     },
--     generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
--     file_sorter =  require'telescope.sorters'.get_fzy_sorter,
--   }
-- }
--Add leader shortcuts
-- vim.api.nvim_set_keymap('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>l', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>t', [[<cmd>lua require('telescope.builtin').tags()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>o', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').git_commits()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>gb', [[<cmd>lua require('telescope.builtin').git_branches()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>gs', [[<cmd>lua require('telescope.builtin').git_status()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>gp', [[<cmd>lua require('telescope.builtin').git_bcommits()<cr>]], { noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>nt', '::NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nj', '::NERDTreeFind<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nf', '::NerdTreeFocus<CR>', { noremap = true, silent = true })
-- Change preview window location
vim.g.splitbelow = true

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true})

-- easier window movement
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Fzf
vim.api.nvim_set_keymap('n', '<leader>ft', ':Rg <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', ':Files <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Buffers <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':GFiles <CR>', { noremap = true, silent = true })

-- Quickfix list
vim.api.nvim_set_keymap('n', '<leader>j', ':cprevious <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':cnext <CR>', { noremap = true, silent = true })

-- Location list
vim.api.nvim_set_keymap('n', '<leader>u', ':lprevious <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>i', ':lnext <CR>', { noremap = true, silent = true })

-- LSP settings
local nvim_lsp = require('lspconfig')
local on_attach = function(_client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'S', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ß', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '´', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist({open_loclist = false})<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
}
----------------------
-- Language Server  --
----------------------

-- rust
nvim_lsp.rust_analyzer.setup {
	on_attach = on_attach,
}

-- gopls
-- taken from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-config
nvim_lsp.gopls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {"gopls", "serve" },
	settings = {
	      gopls = {
		usePlaceholders = true,
		allowImplicitNetworkAccess = true,
		allowModfileModifications = true,
		analyses = {
			unusedparams = true,
		},
		staticcheck = true,
		codelenses = {
			tidy = true,
			upgrade_dependency = true,
			vendor = true,
			generate = true,
			test = true,
		},
	      },
         },
}

function goimports(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
end

vim.api.nvim_command('autocmd BufWritePre *.go lua goimports(1000)')
-- vim.api.nvim_command('autocmd BufWritePre *.go lua vim.lsp.buf.formatting()') -- didn't work, file was changed twice
-- gopls end

-- local sumneko_root_path = vim.fn.getenv("HOME").."/.local/bin/sumneko_lua" -- Change to your sumneko root installation
local sumneko_root_path = vim.fn.getenv("HOME").."/bin/lua-language-server" -- Change to your sumneko root installation
-- local sumneko_binary_path = vim.fn.getenv("HOME").."/bin/lua-language-server" -- Change to your OS specific output folder
local sumneko_binary = "/bin/lua-language-server" -- Change to your OS specific output folder
nvim_lsp.sumneko_lua.setup {
  -- cmd = {sumneko_root_path .. sumneko_binary_path, "-E", sumneko_root_path.."/main.lua" };
  cmd = {sumneko_root_path .. sumneko_binary, "-E", sumneko_root_path.."/main.lua" };
  on_attach = on_attach,
  settings = {
      Lua = {
          runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
          },
          diagnostics = {
              globals = {'vim'},
          },
          workspace = {
              library = {
                  [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                  [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              },
          },
      },
  },
}

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

-- put LSP diagnostics into location list - START

vim.api.nvim_exec([[

augroup Custom_LSP
    autocmd!
    autocmd! BufWrite,BufEnter,InsertLeave * :lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
augroup END
]], false)

-- put LSP diagnostics into location list - END

-- LSP End
-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noinsert"

-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
    ultisnips = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- Configure Tree-sitter
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

vim.bo.spelllang="en_us"

-- Set cursorline for active split / window. Alternative would be
-- https://github.com/TaDaa/vimade or https://github.com/blueyed/vim-diminactive/
vim.wo.cursorline=true
-- lua seems to have no support for autocmd, so we use nvim_command
vim.api.nvim_command([[
autocmd WinEnter * setlocal cursorline
autocmd BufEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
]])


-- vim-go
vim.g.go_version_warning=1
vim.g.go_code_completion_enabled=0 -- use nvim-compe instead
vim.g.go_test_show_name=1
vim.g.go_fmt_autosave=1
vim.g.go_imports_autosave=0 -- already used nvim-lsp
vim.g.go_mod_fmt_autosave=1
vim.g.go_def_mapping_enabled=0
vim.g.go_gopls_enabled=1  -- see what happens
vim.g.go_highlight_string_spellcheck=0
vim.g.go_highlight_format_strings=0
vim.g.go_highlight_diagnostic_errors=0
vim.g.go_highlight_diagnostic_warnings=0
vim.g.go_metalinter_command="golangci-lint" 
vim.g.go_metalinter_autosave=1
-- vim.g.go_fmt_command="goimports" -- automatically format and rewrite imports
vim.g.go_list_type="quickfix"    -- error lista are of type quickfix
-- function should be script-scoped - but lua reports an error, so we change it to a normal function
vim.cmd([[
" run :GoBuild or :GoTestCompile based on the go file
function! ZZZ_Build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call ZZZ_Build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>ta <Plug>(go-test)
autocmd FileType go nmap <leader>tt <Plug>(go-test-func)

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

]])

-- setup gitsigns
require('gitsigns').setup()


-- Mac OS X clipboard sharing
vim.api.nvim_set_option('clipboard', 'unnamed')

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd[[colorscheme onedark]]


