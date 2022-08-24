local mappings = {}

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function mappings.toggleQuickfix()
	local wininfo = vim.fn.getwininfo()
	for _, window in ipairs(wininfo) do
		if window["quickfix"] == 1 then
			vim.cmd("cclose")
			return
		end
	end

	vim.cmd("copen")
end

mappings.keycount = {
	keys = {
		k = {
			count = 0,
		},
		j = {
			count = 0,
		},
	},
	last_pos = nil,
	last_time = nil,
}

local function clear_keycounts()
	for key, _ in pairs(mappings.keycount.keys) do
		mappings.keycount.keys[key] = {
			count = 0,
			origin_line = nil,
			origin_col = nil,
		}
	end
end

function mappings.limitKeystroke(keypressed)
	local allowtime = 1.0
	local allowrepeats = 10

	local count = vim.v.count
	local time = tonumber(vim.fn.reltimestr(vim.fn.reltime()))
	local buftype = vim.api.nvim_buf_get_option(0, "buftype")
	local pos = vim.fn.getcurpos()
	local line = pos[2]
	local col = pos[3]
	local first_line = vim.fn.line("w0")
	local last_line = vim.fn.line("w$")

	local cursor_moved = mappings.keycount.last_pos
		and (mappings.keycount.last_pos.line ~= line or mappings.keycount.last_pos.col ~= col)
	local time_passed = mappings.keycount.last_time and time > mappings.keycount.last_time + allowtime
	local first_line_up = line == first_line and keypressed == "k"
	local last_line_down = line == last_line and keypressed == "j"

	if cursor_moved or time_passed or first_line_up or last_line_down then
		clear_keycounts()
	end

	if count == 0 and buftype ~= "nofile" then
		if mappings.keycount.keys[keypressed].count > allowrepeats then
			vim.api.nvim_err_writeln("too many keystrokes for " .. keypressed .. ". Use Lightspeed!")
			return
		end

		for key, value in pairs(mappings.keycount.keys) do
			if key == keypressed then
				mappings.keycount.keys[key].count = value.count + 1
			else
				mappings.keycount.keys[key].count = 0
			end
		end
		count = 1
	end
	count = (count < 1) and 1 or count

	if keypressed == "k" then
		line = line - count
		line = line >= 1 and line or 1
	elseif keypressed == "j" then
		line = line + count
	end

	mappings.keycount.last_pos = {
		line = line,
		col = col,
	}
	mappings.keycount.last_time = time
	vim.api.nvim_echo({}, false, {})
	vim.fn.cursor(line, col)
end

function mappings.general()
	-- Remap k and j to deal with wraps and with large jumps (which mutate the jumplist)
	-- vim.api.nvim_set_keymap(
	-- 	"n",
	-- 	"k",
	-- 	'v:count == 0 ? "gk" : (v:count > 5 ? "m\'" . v:count : "") . \'k\'',
	-- 	{ noremap = true, expr = true, silent = true }
	-- )
	-- vim.api.nvim_set_keymap(
	-- 	"n",
	-- 	"j",
	-- 	'v:count == 0 ? "gj" : (v:count > 5 ? "m\'" . v:count : "") . \'j\'',
	-- 	{ noremap = true, expr = true, silent = true }
	-- )

	-- limit usage of j and k
	vim.api.nvim_set_keymap(
		"n",
		"k",
		":lua require('mappings').limitKeystroke('k')<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"j",
		":lua require('mappings').limitKeystroke('j')<CR>",
		{ noremap = true, silent = true }
	)

	-- Y yank until the end of line
	vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true })

	-- keep cursor in place when joining lines
	vim.api.nvim_set_keymap("n", "J", "mzJ`z", { noremap = true, silent = true })

	-- keep cursor centered when searching (and open folds)
	vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true, silent = true })

	-- easier window movement
	vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

	-- better indenting
	vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

	-- Move selected line / block of text in visual mode
	vim.api.nvim_set_keymap("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

	-- undo breakpoints for certain signal characters
	-- vim.api.nvim_set_keymap('i', ',', ',<c-g>u', {noremap = true, silent = true})
	-- vim.api.nvim_set_keymap('i', '.', '.<c-g>u', {noremap = true, silent = true})

	-- Quickfix list
	vim.api.nvim_set_keymap("n", "<leader>k", ":cprevious <CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<leader>j", ":cnext <CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap(
		"n",
		"<leader>ll",
		":lua require('mappings').toggleQuickfix() <CR>",
		{ noremap = true, silent = true }
	)

	-- Location list
	vim.api.nvim_set_keymap("n", "<leader>u", ":lprevious <CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<leader>i", ":lnext <CR>", { noremap = true, silent = true })

	-- buffer movement
	vim.api.nvim_set_keymap("n", "X", ":bdelete<CR>", { noremap = true, silent = true })

	vim.api.nvim_set_keymap("n", "W", ":tabc<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "H", ":tabp<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "L", ":tabn<CR>", { noremap = true, silent = true })

	-- vim.api.nvim_set_keymap('n', '^', ':bdelete<CR>', {noremap = true, silent = true})
	vim.api.nvim_set_keymap("i", "<C-^>", "<ESC><C-^>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "`", "<ESC><C-^>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "^", "<ESC><C-^>", { noremap = true, silent = true })

	vim.api.nvim_set_keymap(
		"n",
		"<leader>of",
		":exe ':silent !open -a /Applications/Firefox.app %'<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>oe",
		":exe ':silent !open -a /Applications/Microsoft\\ Edge.app %'<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>oc",
		":exe ':silent !open -a /Applications/Google\\ Chrome.app %'<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>os",
		":exe ':silent !open -a /Applications/Safari.app %'<CR>",
		{ noremap = true, silent = true }
	)
end

--------------------------
-- Plugin related stuff --
--------------------------

function mappings.nvimtree()
	vim.api.nvim_set_keymap("n", "<leader>nt", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<leader>nj", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
end

function mappings.telescope()
	vim.api.nvim_set_keymap(
		"n",
		"<leader>fb",
		[[<cmd>lua require('telescope.builtin').file_browser()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("n", "<Leader>,", ":Telescope buffers<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>faf",
		[[<cmd>lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>fgf",
		[[<Cmd>lua require('telescope.builtin').git_files()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("n", "<Leader>fof", ":Telescope oldfiles<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>fgs", ":Telescope git_status<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>fgb", ":Telescope git_branches<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>fgc", ":Telescope git_commits<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>fgC", ":Telescope git_bcommits<CR>", { noremap = true, silent = true }) -- current file
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>fld",
		":Telescope lsp_workspace_diagnostics<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>flD",
		":Telescope lsp_document_diagnostics<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>ft",
		[[<cmd>lua require('telescope.builtin').live_grep()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>fr",
		[[<cmd>lua require('telescope.builtin').resume()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>fT",
		[[<cmd>lua require('telescope.builtin').search_history()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>fz",
		[[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>f*",
		[[<cmd>lua require('telescope.builtin').grep_string()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>fk",
		[[<cmd>lua require('telescope.builtin').keymaps()<cr>]],
		{ noremap = true, silent = true }
	)

	vim.api.nvim_set_keymap(
		"n",
		"gr",
		[[<cmd>lua require('telescope.builtin').lsp_references()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gi",
		[[<cmd>lua require('telescope.builtin').lsp_implementations()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"gd",
		[[<cmd>lua require('telescope.builtin').lsp_definitions()<cr>]],
		{ noremap = true, silent = true }
	)
end

function mappings.trouble()
	vim.api.nvim_set_keymap("n", "<leader>ld", ":TroubleToggle<CR>", { noremap = true, silent = true })
end

function mappings.dap()
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dbb",
		[[<cmd>lua require'dap'.toggle_breakpoint()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dbc",
		[[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dbl",
		[[<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dc",
		[[<cmd>lua require'dap'.continue()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dl",
		[[<cmd>lua require'dap'.step_over()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dk",
		[[<cmd>lua require'dap'.step_out()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dj",
		[[<cmd>lua require'dap'.step_into()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dr",
		[[<cmd>lua require'dap'.repl_open()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>dl",
		[[<cmd>lua require'dap'.run_last()<CR>]],
		{ noremap = true, silent = true }
	)

	-- key mappings from https://github.com/alpha2phi/dotfiles/blob/main/config/nvim/lua/dbg/init.lua
	map("n", "<leader>dct", '<cmd>lua require"dap".continue()<CR>')
	map("n", "<leader>dsv", '<cmd>lua require"dap".step_over()<CR>')
	map("n", "<leader>dsi", '<cmd>lua require"dap".step_into()<CR>')
	map("n", "<leader>dso", '<cmd>lua require"dap".step_out()<CR>')
	map("n", "<leader>dtb", '<cmd>lua require"dap".toggle_breakpoint()<CR>')

	map("n", "<leader>dsc", '<cmd>lua require"dap.ui.variable".scopes()<CR>')
	map("n", "<leader>dhh", '<cmd>lua require"dap.ui.variables".hover()<CR>')
	map("v", "<leader>dhv", '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')

	map("n", "<leader>duh", '<cmd>lua require"dap.ui.widgets".hover()<CR>')
	map("n", "<leader>duf", "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")

	map("n", "<leader>dsbr", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
	map("n", "<leader>dsbm", '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
	map("n", "<leader>dro", '<cmd>lua require"dap".repl.open()<CR>')
	map("n", "<leader>drl", '<cmd>lua require"dap".repl.run_last()<CR>')

	-- telescope-dap
	map("n", "<leader>dcc", '<cmd>lua require"telescope".extensions.dap.commands{}<CR>')
	map("n", "<leader>dco", '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>')
	map("n", "<leader>dlb", '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>')
	map("n", "<leader>dv", '<cmd>lua require"telescope".extensions.dap.variables{}<CR>')
	map("n", "<leader>df", '<cmd>lua require"telescope".extensions.dap.frames{}<CR>')

	-- nvim-dap-ui
	map("n", "<leader>dui", '<cmd>lua require"dapui".toggle()<CR>')

	-- target mapping
	map("n", "<A-Left>", '<cmd>lua require"dap".continue()<CR>')
	map("n", "<A-Right>", '<cmd>lua require"dap".step_over()<CR>')
	map("n", "<A-Down>", '<cmd>lua require"dap".step_into()<CR>')
	map("n", "<A-Up>", '<cmd>lua require"dap".step_out()<CR>')
	map("n", "<A-CR>", '<cmd>lua require"dap".toggle_breakpoint()<CR>')
	map("n", "<leader>fdc", '<cmd>lua require"telescope".extensions.dap.commands{}<CR>')
	map("n", "<leader>fdb", '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>')
end

function mappings.restnvim()
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>e",
		[[<cmd>lua require'rest-nvim'.run()<cr>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>E",
		[[<cmd>lua require'rest-nvim'.run(true)<cr>]],
		{ noremap = true, silent = true }
	)
end

function mappings.lsp(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl", "<cmd>lua vim.lsp.buf.list_workspace_folders()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<CR>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>d",
		"<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "ß", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "´", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "-", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "=", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>q",
		"<cmd>lua vim.lsp.diagnostic.set_loclist({open_loclist = false})<CR>",
		opts
	)
end

function mappings.fugitive()
	map("n", "<leader>gs", ":Git<CR>") -- like git status
	map("n", "<leader>gdd", ":Gvdiffsplit<CR>") -- git diff current file
	map("n", "<leader>gdl", ":Git difftool<CR>") -- git diff output into quickfix list
	map("n", "<leader>gm", ":Gvdiffsplit!<CR>") -- git diff and merge current file
	map("n", "<leader>ga", ":diffget //2<CR>")
	map("n", "<leader>g;", ":diffget //3<CR>")
	map("n", "<leader>gc", ":0Gclog<CR>") -- commit history of current file into quickfix list
	vim.api.nvim_create_user_command("Review", ":lua require('mappings').git_review(<q-args>)", { nargs = "?" })
end

function mappings.git_review(branch)
	if branch == nil or branch == "" then
		branch = vim.fn.input("Enter branch name to diff against: ", "master")
	end
	require("gitsigns").change_base(branch, true)
	vim.cmd("Git difftool " .. branch)
end

function mappings.gitsigns(bufnr)
	local function map_buffer(mode, lhs, rhs, opts)
		opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
		vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
	end
	-- Navigation
	map_buffer("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
	map_buffer("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

	map_buffer("n", "<leader>gb", '<cmd>lua require"gitsigns".blame_line()<CR>')

	-- Text object
	map_buffer("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
	map_buffer("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")

	-- Actions
	-- currently unused mappings
	map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
	map("v", "<leader>hs", ":Gitsigns stage_hunk<CR>")
	map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
	map("v", "<leader>hr", ":Gitsigns reset_hunk<CR>")
	map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
	map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
	map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
	map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
	map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
	map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
	map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
	map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
end

function mappings.neogit()
	map("n", "<leader>G", '<cmd>lua require"neogit".open({kind = "split_above"})<CR>')
end

function mappings.maximizer()
	map("n", "<leader>m", ":MaximizerToggle!<CR>")
end

function mappings.rusttools()
	map("n", "<leader>rex", ":RustExpandMacro<CR>")
	map("n", "<leader>rr", ":RustRunnables<CR>")
end

function mappings.copilot()
	map("i", "<C-a>", "<Plug>(copilot-previous)", { noremap = false })
	map("i", "<C-s>", "<Plug>(copilot-next)", { noremap = false })
	map("i", "<C-x>", "<Plug>(copilot-dismiss)", { noremap = false })
	-- map("i", "<C-a>", "copilot#Previous()", { expr = true })
	-- map("i", "<C-s>", "copilot#Next()", { expr = true })
	-- map("i", "<C-x>", "copilot#Dismiss()", { expr = true })
	-- map("i", "<F3>", "<Plug>(copilot-previous)", { noremap = false })
	-- map("i", "<F4>", "<Plug>(copilot-next)", { noremap = false })
	-- map("i", "<F1>", "<C-o>:echo 'hallo a'<CR>")
	-- map("i", "<F2>", "<C-o>:echo 'hallo s'<CR>")
end

function mappings.nvim_luadev()
	map("n", "<leader>ell", "<Plug>(Luadev-RunLine)", { noremap = false })
	map("n", "<leader>elr", "<Plug>(Luadev-Run)", { noremap = false })
	map("v", "<leader>elr", "<Plug>(Luadev-Run)", { noremap = false })
	map("n", "<leader>elw", "<Plug>(Luadev-RunWord)", { noremap = false })
	map("i", "<C-c>", "<Plug>(Luadev-Complete)", { noremap = false })
end

return mappings
